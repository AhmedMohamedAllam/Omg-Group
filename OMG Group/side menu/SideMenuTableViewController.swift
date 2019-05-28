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
        selectCell(at: indexPath)
        delegate?.didSelectItem(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        deselectCell(at: indexPath)
    }
    
    private func selectCell(at indexPath: IndexPath ){
        updateCell(isSelected: true, at: indexPath)
    }
    
    private func deselectCell(at indexPath: IndexPath ){
        updateCell(isSelected: false, at: indexPath)
    }
    
    private func updateCell(isSelected: Bool, at indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        let containerView = cell?.subviews.first?.subviews
        let iconImageView = containerView?.filter{$0.tag == 0}.first as? UIImageView
        let label = containerView?.filter{$0.tag == 1}.first as? UILabel
        let iconName = isSelected ? "red-sidemenu-\(indexPath.row)" : "sidemenu-\(indexPath.row)"
        iconImageView?.image = UIImage(named: iconName)
        label?.textColor = isSelected ? UIColor.red : UIColor.white
        tableView.rectForRow(at: indexPath)
    }
    
    
    
}
