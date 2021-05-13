//
//  DriverOrderHistoryView.swift
//  ErryBody Eats
//
//  Created by Daniyal Khan on 12/7/20.
//

import Foundation
import SwiftUI
import Firebase

struct DriverOrderHistoryView: View {
    @ObservedObject var homeData: DriverHomeViewModel
    var body: some View {
        if Auth.auth().currentUser != nil {
        VStack(spacing: 10){
        
            HStack(spacing: 20){
                NavigationLink(destination: DriverHome()){
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.pink)
                }
                
                Text("Order History")
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                
            }
            .padding([.horizontal,.top])
            
            Divider()
            
            Spacer()
            
            
            ScrollView(.vertical, showsIndicators: false, content: {
                Divider()
                
                VStack(spacing: 20){
                    ForEach(homeData.completedOrders){Order in
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
                .padding(.top,10)
            })
            
            Spacer()
        }.onAppear(perform: {
            // login to database
            homeData.getCompletedOrders()
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
}

