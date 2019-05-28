//
//  Extensions.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/29/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import UIKit
extension UINavigationController{
    func makeTransparent() {
        navigationBar.isHidden = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = .clear
    }
}
