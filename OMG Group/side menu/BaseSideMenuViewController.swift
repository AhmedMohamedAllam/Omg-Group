//
//  BaseSideViewController.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/28/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import UIKit

class BaseSideMenuViewController: UIViewController {

    weak var delegate: SideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sideMenuTableViewController = segue.destination as? SideMenuTableViewController{
            sideMenuTableViewController.delegate = delegate
        }
    }

}
