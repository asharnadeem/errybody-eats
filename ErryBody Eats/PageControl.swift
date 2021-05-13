//
//  PageControl.swift
//  Food Delivery App
//
//  Created by Daniyal Khan on 9/15/20.
//  Copyright © 2020 Daniyal Khan. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    
    @Binding var currentPageIndex: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPageIndicatorTintColor = UIColor.systemPink
        control.pageIndicatorTintColor = UIColor.gray

        return control
           
       }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPageIndex
    }
    
}
