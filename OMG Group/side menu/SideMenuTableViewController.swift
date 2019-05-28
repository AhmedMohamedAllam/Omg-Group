//
//  SideMenuTableViewController.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/28/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import UIKit

protocol SideMenuDelegate: class {
    func didSelectItem(at index: Int)
}

class SideMenuTableViewController: UITableViewController {
    weak var delegate: SideMenuDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
    

}
