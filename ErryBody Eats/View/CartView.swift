//
//  CartView.swift
//  ErryBody Eats
//
//  Created by Daniyal Khan on 11/15/20.
//

import Foundation
import SwiftUI
import Firebase
import Braintree
import BraintreeDropIn

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    var body: some View {
        if Auth.auth().currentUser != nil {
        VStack(spacing: 10){
        
            HStack(spacing: 20){
                NavigationLink(destination: CustomerHome()){
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.pink)
                }
                
                Text("Your Orders")
                    .foregroundColor(.black)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
            }
            .padding([.horizontal,.top])
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false, content: {                
                HStack{
                    Text("Accepted")
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding([.horizontal])
                        .foregroundColor(.pink)
                    
                    Spacer()
                }
                
                Divider()
                
                VStack(spacing: 20){
                    ForEach(homeData.acceptedOrders){Order in
                     //   Button(action: {self.displayOrderScreen = true; self.orderPressed=Delivery}) {
                            HStack{
                                VStack{
                                    HStack(spacing: 8){
                                        
                                        Text(Order.restaurant)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        
                                        Spacer(minLength: 0)
                                        
                                    }.padding(.bottom,2)
                                    
                                    HStack{
                                        
                                        Text(Order.name)
                                            .font(.title3)
                                            .foregroundColor(.black)
                                            .lineLimit(2)
                                        
                                        Spacer(minLength: 0)
                                        
                                        // Ratings View....
                                        
                                        ForEach(1...5,id: \.self){index in
                                            
                                            Image(systemName: "star.fill")
                                                .foregroundColor(index <= Int(truncating: Order.rating) ? .pink : .gray)
                                        }
                                                                               
                                    }
                                    //.padding(.leading, 20)
                                    
                                    Spacer()
                                    
                                    HStack(){
                                    
                                        Text(Order.order)
                                            .font(.title3)
                                            .foregroundColor(Color(UIColor.darkGray.cgColor))
                                        
                                        Spacer(minLength: 0)
                                        
                                        NavigationLink(destination: ChatView(homeData: homeData, driver_id: Order.deliveryID, name: Order.name)) {
                                            HStack(spacing: 15){
                                                Image(systemName: "message")
                                                    .font(.title)
                                                    .foregroundColor(.pink)
                                            }
                                        }
                                        
                                        NavigationLink(destination: OrderView(HomeModel: homeData)) {
                                            HStack(spacing: 15){
                                                Image(systemName: "map")
                                                    .font(.title)
                                                    .foregroundColor(.pink)
                                            }
                                        }
                                        
                                        Button(action: {
                                            showDropIn()
                                        }) {
                                            HStack(spacing: 15){
                                                Image(systemName: "dollarsign.circle")
                                                    .font(.title)
                                                    .foregroundColor(.pink)
                                            }
                                        }
                                        
                                        NavigationLink(destination: finishedView(order: Order)) {
                                            HStack(spacing: 15){
                                                Image(systemName: "checkmark")
                                                    .font(.title)
                                                    .foregroundColor(.pink)
                                            }
                                        }
                                    }
                                    
                                }
                                    .frame(width: UIScreen.main.bounds.width - 30)
                                    //.border(Color.gray)
                            }
                      //  }
                        
                        Divider()
                    }
                }
                
                HStack{
                    Text("Pending")
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding([.horizontal, .top])
                        .foregroundColor(.pink)
                    
                    Spacer()
                }
                
                Divider()
                
                VStack(spacing: 20){
                    ForEach(homeData.orders){Order in
                     //   Button(action: {self.displayOrderScreen = true; self.orderPressed=Delivery}) {
                            HStack{
                                VStack{
                                    HStack(spacing: 8){
                                        
                                        Text(Order.restaurant)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        
                                        Spacer(minLength: 0)
                                        
                                    }.padding(.bottom,2)
                                    
                                    HStack{
                                        
                                        Text(Order.name)
                                            .font(.title3)
                                            .foregroundColor(.black)
                                            .lineLimit(2)
                                        
                                        Spacer(minLength: 0)
                                        
                                        // Ratings View....
                                        
                                        ForEach(1...5,id: \.self){index in
                                            
                                            Image(systemName: "star.fill")
                                                .foregroundColor(index <= Int(truncating: Order.rating) ? .pink : .gray)
                                        }
                                                                               
                                    }
                                    //.padding(.leading, 20)
                                    
                                    Spacer()
                                    
                                    HStack(){
                                    
                                        Text(Order.order)
                                            .font(.title3)
                                            .foregroundColor(Color(UIColor.darkGray.cgColor))
                                        
                                        Spacer(minLength: 0)
        
                                    }
                                    
                                }
                                    .frame(width: UIScreen.main.bounds.width - 30)
                                    //.border(Color.gray)
                            }
                      //  }
                        
                        Divider()
                    }
                }
                                
            }).padding(.top,10)
            
            Spacer()
        }.onAppear(perform: {
            // login to database
            homeData.getAcceptedOrders()
            homeData.getOrders()
        }).navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        }
        
        else{
            NavigationView{
               WelcomeView()
                   .navigationBarHidden(true)
                   .navigationBarBackButtonHidden(true)
            }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            Spacer()
        }
    }
    
    
  /*  var body: some View {
        ZStack {
            Text("sfsf")
            VStack(spacing: 10){
                
                HStack(spacing: 15){
                
                NavigationLink(destination: CustomerHome()){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(Color("pink"))
                }
                
                Text("Your Orders")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                }
            
            }
            
            Divider()
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    
    }
 */
    
    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    func showDropIn() {
        let request =  BTDropInRequest()
        request.venmoDisabled = false
        let dropIn = BTDropInController(authorization: "sandbox_24n78qmh_58xryxxjqmht9p82", request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                let selectedPaymentOptionType = result.paymentOptionType
                let selectedPaymentMethod = result.paymentMethod
                let selectedPaymentMethodIcon = result.paymentIcon
                let selectedPaymentMethodDescription = result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.window?.rootViewController?.present(dropIn!, animated: true, completion: nil)
    }
    

}

/*struct CartView_Previews: PreviewProvider {
    static var previews: some View {
       // CartView()
    }
}*/


