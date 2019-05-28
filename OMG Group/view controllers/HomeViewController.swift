//
//  HomeViewController.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/28/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import UIKit
import SideMenu
import AVKit

class HomeViewController: UIViewController {
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSidemenuGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentTVStream()
    }
    
    fileprivate func configureSidemenuGestures() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuLeftNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sideMenuSegue", let destination = segue.destination as? UISideMenuNavigationController, let baseMenuVC = destination.children.first as? BaseSideMenuViewController{
            baseMenuVC.delegate = self
        }
    }
    
    private func presentTVStream(){
        let url = ApiManager.getTVStreamUrl()
        player = AVPlayer(url: url)
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        player.allowsExternalPlayback = true
        checkError()
        present(playerViewController, animated: true){
            DispatchQueue.main.async {
                self.player.play()
            }
            
        }
    }
    
    private func presentRadioStream(){
        
    }
    
    
    func checkError() {
        // Get AVPlayerItem
        
        // Get AVPlayer
        
        // Add observer for AVPlayer status and AVPlayerItem status
        self.player.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .initial], context: nil)
        self.player.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options:[.new, .initial], context: nil)
        
        // Watch notifications
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(newErrorLogEntry(_:)), name: .AVPlayerItemNewErrorLogEntry, object: player.currentItem)
        center.addObserver(self, selector: #selector(failedToPlayToEndTime(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: player.currentItem)
    }
    
    // Observe If AVPlayerItem.status Changed to Fail
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayer.currentItem.status) {
            let newStatus: AVPlayerItem.Status
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue)!
            } else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                NSLog("Error: \(String(describing: self.player?.currentItem?.error?.localizedDescription)), error: \(String(describing: self.player?.currentItem?.error))")
            }
        }
    }
    
    // Getting error from Notification payload
    @objc func newErrorLogEntry(_ notification: Notification) {
        guard let object = notification.object, let playerItem = object as? AVPlayerItem else {
            return
        }
        guard let errorLog: AVPlayerItemErrorLog = playerItem.errorLog() else {
            return
        }
        NSLog("Error: \(errorLog)")
    }
    
    @objc func failedToPlayToEndTime(_ notification: Notification) {
        let error = notification.userInfo!["AVPlayerItemFailedToPlayToEndTimeErrorKey"] as! Error
        NSLog("Error: \(error.localizedDescription), error: \(error)")
    }
    
}

extension HomeViewController: SideMenuDelegate{
    func didSelectItem(at index: Int) {
        print(index)
    }
    
    
}
