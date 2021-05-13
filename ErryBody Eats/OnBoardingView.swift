//
//  OnBoardingView.swift
//  Food Delivery App
//
//  Created by Daniyal Khan on 9/15/20.
//  Copyright © 2020 Daniyal Khan. All rights reserved.
//

import SwiftUI
import Firebase

struct OnBoardingView: View {
    var titles = ["Get paid to pickup food", "Food delivered to you", "Create new connections"]
    var captions =  ["Getting food? Let everyone else know so you can get paid for it.", "Hungry but don't have a ride? Find who does to get food delivered straight to you.", "Meet new people who share the same love for the food that you do."]
    @State var currentPageIndex = 0
    @State var GoToView2:Bool = false
    
    var subviews = [
        UIHostingController(rootView: OnBoardingSubview(imageString: "choose")),
        UIHostingController(rootView: OnBoardingSubview(imageString: "discover")),
        UIHostingController(rootView: OnBoardingSubview(imageString: "location"))
    ]
    
    var body: some View {
        
        return Group {
        if GoToView2 {
            NavigationView{
                WelcomeView()
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            }
        } else {
            if Auth.auth().currentUser == nil {
                VStack(alignment: .leading) {
                    PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
                        //.frame(height: 400)
                    Group {
                        Text(titles[currentPageIndex])
                            .font(.title)
                        Text(captions[currentPageIndex])
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        //.frame(width: 300, height: 50, alignment: .leading)
                        .lineLimit(nil)
                    }
                        .padding()
                    HStack {
                        PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                        Spacer()
                        Button(action: {
                            if self.currentPageIndex == 2 {
                                self.GoToView2.toggle()
                            }
                            if self.currentPageIndex+1 == self.subviews.count {
                                self.currentPageIndex = 0
                            } else {
                                self.currentPageIndex += 1
                            }
                        }) {
                            ButtonContent()
                        }
                    }
                        .padding()
                }
        }
            else{
                NavigationView{
                    WelcomeView()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
            }
    }
    }
    }
    
    struct ButtonContent: View {
        var body: some View {
            Image(systemName: "arrow.right.circle.fill")
                .resizable()
                .foregroundColor(.pink)
                .frame(width: 60, height: 60)
                .padding()
                //.background(Color.orange)
                //.cornerRadius(30)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
