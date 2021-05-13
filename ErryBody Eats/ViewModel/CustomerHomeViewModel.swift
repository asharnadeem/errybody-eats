//
//  CustomerHomeViewModel.swift
//  ErryBody Eats
//
//  Created by Daniyal Khan on 11/14/20.
//

import Foundation
import SwiftUI
import Firebase
import CoreLocation

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var showMenu = false
    @Published var deliveries: [Delivery] = []
    @Published var orders: [Order] = []
    @Published var acceptedOrders: [Order] = []
    @Published var completedOrders: [Order] = []
    @Published var messages: [Message] = []
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    @Published var users: [User] = []
    var fetchDataListener: ListenerRegistration? = nil
    var getOrdersListener: ListenerRegistration? = nil
    var recvMsgListener: ListenerRegistration? = nil
    var sentMsgListener: ListenerRegistration? = nil

    var completeOrdersListener: ListenerRegistration? = nil
    
    var uid = Auth.auth().currentUser!.uid
    
    // anon login to Firebase Database
    func login(){
        
        Auth.auth().signInAnonymously { (res, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            print("Success = \(res!.user.uid)")
            
            // After Logging in Fetching Data
            
            self.fetchData()
        }
    }
    
    // Fetching Delivery Data
    
    func fetchData(){
        
        let db = Firestore.firestore()
        
        fetchDataListener = db.collection("deliveries").addSnapshotListener { querySnapshot, error in
            
            guard let deliveryData = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.deliveries = deliveryData.compactMap({ (doc) -> Delivery? in
                
                print(doc.data())
                let db_id = doc.documentID
                let db_driverid = doc.get("driver_id") as! String
               // let db_name = doc.get("name") as! String
                let db_notes = doc.get("notes") as! String
                let db_restaurant = doc.get("restaurant") as! String
                let db_time_window = doc.get("time_window") as! NSNumber
                let db_rating = doc.get("rating") as! NSNumber
                let db_category = doc.get("category") as! String
                
                return Delivery(id: db_id, driver_id: db_driverid, rating: db_rating, notes: db_notes, restaurant: db_restaurant, time_window: db_time_window, category: db_category)
            })
            
            self.getDeliveryNames()
            
        }
    }
    
    func sendOrder(delivery: Delivery, order: String){
        
        let db = Firestore.firestore()
        
        db.collection("orders").addDocument(data: [
            
            "delivery_id": delivery.driver_id,
            "customer_id": uid,
            "order": order,
            "name": delivery.name,
            "restaurant": delivery.restaurant,
            "rating": delivery.rating
        ])
    }
    
    func getOrders(){
        
        let db = Firestore.firestore()
        
        getOrdersListener = db.collection("orders").whereField("customer_id", isEqualTo: self.uid).addSnapshotListener { querySnapshot, error in
            
            guard let orderData = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.orders = orderData.compactMap({ (doc) -> Order? in
                
                let db_id = doc.documentID
                let db_deliveryid = doc.get("delivery_id") as! String
                let db_customerid = doc.get("customer_id") as! String
                let db_order = doc.get("order") as! String
                let db_restaurant = doc.get("restaurant") as! String
                let db_rating = doc.get("rating") as! NSNumber
                //let db_name = doc.get("name") as! String
                
                return Order(id: db_id, deliveryID: db_deliveryid, customerID: db_customerid, order: db_order, rating: db_rating, restaurant: db_restaurant)
            })
            
            self.getNames()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //check location status
        switch manager.authorizationStatus{
        case .authorizedWhenInUse:
            print("Authorized")
        case .denied:
            print("Denied")
        default:
            print("Unknown")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
    
    func getSentMessages(driverId: String){
        sentMsgListener?.remove()
        
        let db = Firestore.firestore()
        
        sentMsgListener = db.collection("messages").whereField("fromId", isEqualTo: uid).whereField("toId", isEqualTo: driverId).order(by: "timestamp", descending: false).addSnapshotListener { querySnapshot, error in
            
            guard let messageData = querySnapshot?.documentChanges else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.messages.append(contentsOf: messageData.compactMap({ (doc) -> Message? in
                
                let db_id = doc.document.documentID
                let db_fromId = doc.document.get("fromId") as! String
                let db_toId = doc.document.get("toId") as! String
                let db_message = doc.document.get("message") as! String
                let db_timestamp = doc.document.get("timestamp") as! Int
                
                return Message(id: db_id, fromId: db_fromId, message: db_message, timestamp: db_timestamp, toId: db_toId)
            }))
            
            self.messages.sort{ $0.timestamp < $1.timestamp }
        }
    }
    
    func getRecvMessages(driverId: String){
        recvMsgListener?.remove()
        
        let db = Firestore.firestore()
        
        recvMsgListener = db.collection("messages").whereField("toId", isEqualTo: uid).whereField("fromId", isEqualTo: driverId).order(by: "timestamp", descending: false).addSnapshotListener { querySnapshot, error in
            
            guard let messageData = querySnapshot?.documentChanges else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.messages.append(contentsOf: messageData.compactMap({ (doc) -> Message? in
                
                let db_id = doc.document.documentID
                let db_fromId = doc.document.get("fromId") as! String
                let db_toId = doc.document.get("toId") as! String
                let db_message = doc.document.get("message") as! String
                let db_timestamp = doc.document.get("timestamp") as! Int
                
                return Message(id: db_id, fromId: db_fromId, message: db_message, timestamp: db_timestamp, toId: db_toId)
            }))
            
            self.messages.sort{ $0.timestamp < $1.timestamp }
        }
        
    }
    
    
    func getUserData(uid: String){
        
        let db = Firestore.firestore()
        
        db.collection("users").whereField("id", isEqualTo: uid).getDocuments { (snap, err) in
            guard let userData = snap else{return}
            
            self.users = userData.documents.compactMap({ (doc) -> User? in
                
                let db_docid = doc.documentID
                let db_email = doc.get("email") as! String
                let db_id = doc.get("id") as! String
                let db_first_name = doc.get("first_name") as! String
                let db_last_name = doc.get("last_name") as! String
                let db_venmoID = doc.get("venmoID") as! String
                let db_ratingAvg = doc.get("ratingAvg") as! Float
                let db_ratingsTotal = doc.get("ratingsTotal") as! Int
                print(db_first_name)
                print(db_last_name)
                
                
                return User(docid: db_docid, id: db_id, email: db_email, first_name: db_first_name, last_name: db_last_name, venmoID: db_venmoID, ratingAvg: db_ratingAvg, ratingsTotal: db_ratingsTotal)
            })
        }
    }
    
    func updateUserRating(uid: String, ratingAvg: Float, ratingsTotal: Int, db_docid: String){
        let db = Firestore.firestore()
        db.collection("users").document(db_docid).updateData(["ratingAvg": ratingAvg, "ratingsTotal": ratingsTotal])
    }
    
    func getUserEmail(uid: String) ->String{
        getUserData(uid: uid)
        var i = 0
        while i < users.count {
            if(users[i].id == uid){
                return users[i].first_name
            }
            i+=1
        }
        return ""
    }
    
    func updateDriverRating(uid: String, ratingAvg: Float, db_docid: String){
        print("Updating Driver Rating")
        print(db_docid)
        let db = Firestore.firestore()
        db.collection("deliveries").document(db_docid).updateData(["rating": ratingAvg])
    }
    
    func updateOrderRating(uid: String, ratingAvg: Float, db_docid: String){
        print("Updating Order Rating")
        print(db_docid)
        let db = Firestore.firestore()
        db.collection("orders").document(db_docid).updateData(["rating": ratingAvg])
    }
    
    func getDelRating(deliveryid: String){
        //var ratingUser = 0
        //var i = 0
        
        let db = Firestore.firestore()
        
        db.collection("users").whereField("id", isEqualTo: deliveryid).getDocuments { (snap, err) in
            
            guard let userData = snap else{return}
            
            self.users = userData.documents.map({ QueryDocumentSnapshot -> User in
                let data = QueryDocumentSnapshot.data()
                let db_ratingAvg = data["ratingAvg"] as! Float
                let db_ratingTotal = data["ratingsTotal"] as! Int
                //print(db_ratingAvg)
                //pubRating = db_ratingAvg
                return User(ratingAvg: db_ratingAvg, ratingsTotal: db_ratingTotal)
            })
            
        }
    }
    
    func sendMessage(toId: String, message: String){
        
        let db = Firestore.firestore()
        db.collection("messages").addDocument(data: ["fromId": uid, "toId": toId, "message": message, "timestamp": Int(Date().timeIntervalSince1970)])
    }
    
    func getAcceptedOrders(){
        let db = Firestore.firestore()
        
        db.collection("orders_accepted").whereField("customer_id", isEqualTo: self.uid).addSnapshotListener { querySnapshot, error in
            
            guard let orderData = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.acceptedOrders = orderData.compactMap({ (doc) -> Order? in
                
                let db_id = doc.documentID
                let db_deliveryid = doc.get("delivery_id") as! String
                let db_customerid = doc.get("customer_id") as! String
                let db_order = doc.get("order") as! String
                let db_restaurant = doc.get("restaurant") as! String
                let db_rating = doc.get("rating") as! NSNumber
                //let db_name = doc.get("name") as! String
                
                return Order(id: db_id, deliveryID: db_deliveryid, customerID: db_customerid, order: db_order, rating: db_rating, restaurant: db_restaurant)
            })
            
            self.getAcceptedNames()
        }
    }
    
    func completeOrder(order: Order) {
        
        let db = Firestore.firestore()
        let db_order = db.collection("orders_accepted").document(order.id)
        db_order.updateData([
            "customer_completed": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        db_order.getDocument { (document, error) in
            if let document = document, document.exists {
                let driver_completed = document.get("driver_completed") as! Bool
                if(driver_completed == true){
                    db.collection("orders_completed").addDocument(data: [
                        
                        "delivery_id": order.deliveryID,
                        "customer_id": order.customerID,
                        "order": order.order,
                        "name": order.name,
                        "restaurant": order.restaurant,
                    ])
                    
                    db_order.delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getCompletedOrders(){
        let db = Firestore.firestore()
        
        db.collection("orders_completed").whereField("customer_id", isEqualTo: self.uid).addSnapshotListener { querySnapshot, error in
            
            guard let orderData = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.completedOrders = orderData.compactMap({ (doc) -> Order? in
                
                let db_id = doc.documentID
                let db_deliveryid = doc.get("delivery_id") as! String
                let db_customerid = doc.get("customer_id") as! String
                let db_order = doc.get("order") as! String
                let db_restaurant = doc.get("restaurant") as! String
               // let db_name = doc.get("name") as! String
                
                return Order(id: db_id, deliveryID: db_deliveryid, customerID: db_customerid, order: db_order, restaurant: db_restaurant)
            })
            
            self.getCompletedNames()
        }
    }
    
    func getDeliveryNames(){
        let db = Firestore.firestore()
        var driverName = ""
        
        for (index, delivery) in deliveries.enumerated(){
        
            db.collection("users").whereField("id", isEqualTo: delivery.driver_id)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let firstName = document.get("first_name") as! String
                            let lastName = document.get("last_name") as! String
                            driverName = firstName + " " + lastName
                            print(driverName)
                            self.deliveries[index].name = driverName
                        }
                    }
            }
        }
    }
    
    func getNames(){
        let db = Firestore.firestore()
        var driverName = ""
        
        for (index, order) in orders.enumerated(){
        
            db.collection("users").whereField("id", isEqualTo: order.deliveryID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let firstName = document.get("first_name") as! String
                            let lastName = document.get("last_name") as! String
                            driverName = firstName + " " + lastName
                            print(driverName)
                            self.orders[index].name = driverName
                        }
                    }
            }
        }
    }
    
    func getAcceptedNames(){
        let db = Firestore.firestore()
        var driverName = ""
        
        for (index, order) in acceptedOrders.enumerated(){
        
            db.collection("users").whereField("id", isEqualTo: order.deliveryID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let firstName = document.get("first_name") as! String
                            let lastName = document.get("last_name") as! String
                            driverName = firstName + " " + lastName
                            print(driverName)
                            self.acceptedOrders[index].name = driverName
                        }
                    }
            }
        }
    }
    
    func getCompletedNames(){
        let db = Firestore.firestore()
        var driverName = ""
        
        for (index, order) in completedOrders.enumerated(){
        
            db.collection("users").whereField("id", isEqualTo: order.deliveryID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let firstName = document.get("first_name") as! String
                            let lastName = document.get("last_name") as! String
                            driverName = firstName + " " + lastName
                            print(driverName)
                            self.completedOrders[index].name = driverName
                        }
                    }
            }
        }
    }
    
    func removeListeners(){
        fetchDataListener?.remove()
        getOrdersListener?.remove()
    }
    
}

