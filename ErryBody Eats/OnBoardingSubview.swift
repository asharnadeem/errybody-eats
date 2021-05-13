//
//  OnBoardingSubview.swift
//  Food Delivery App
//
//  Created by Daniyal Khan on 9/15/20.
//  Copyright © 2020 Daniyal Khan. All rights reserved.
//

import SwiftUI
import Firebase

struct OnBoardingSubview: View {
   
        var imageString: String
        var body: some View {
        if Auth.auth().currentUser == nil {
            Image(imageString)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipped()
        }
    }
}

struct OnBoardingSubview_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingSubview(imageString: "choose")
    }
}
