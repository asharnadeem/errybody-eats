//
//  OrdersAvailableView.swift
//  ErryBody Eats
//
//  Created by Daniyal Khan on 12/1/20.
//

import Foundation

import Foundation
import SwiftUI
import Firebase

struct OrdersAvailableView: View {
    var homeData: DriverHomeViewModel
    var order: Order
    var body: some View {

        HStack{
            VStack{
                HStack(spacing: 8){
                    
                    Text(order.restaurant)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                    
                }.padding(.bottom,2)
                
                HStack{
                    
                    Text(order.name)
                        .font(.title3)
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    Spacer(minLength: 0)
                    
                    // Ratings View....
                    
                    ForEach(1...5,id: \.self){index in
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(index <= Int(truncating: order.rating) ? .pink : .gray)
                    }
                                                           
                }
                //.padding(.leading, 20)
                
                Spacer()
                
                HStack(){
                
                    Text(order.order)
                        .font(.title3)
                        .foregroundColor(Color(UIColor.darkGray.cgColor))
                    
                    Spacer(minLength: 0)
                    
                  //  NavigationLink(destination: DriverCartView(homeData: homeData)) {
                        HStack(spacing: 15){
                            Image(systemName: "checkmark")
                                .font(.title)
                                .foregroundColor(.pink)
                        }.simultaneousGesture(TapGesture().onEnded{
                            homeData.acceptOrder(order: order)
                        })
                }
            }
                //.border(Color.gray)
        }

    }
}

struct OrdersAvailableView_Previews: PreviewProvider {
        static var previews: some View {
            /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
        }
}

