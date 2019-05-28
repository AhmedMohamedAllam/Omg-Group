//
//  ViewController.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/28/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import UIKit
import SideMenu

class BaseSideMenuViewController: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSidemenuGestures()
    }
    
    fileprivate func configureSidemenuGestures() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuLeftNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
}

