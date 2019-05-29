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
import MediaPlayer


class HomeViewController: UIViewController {
    let playerViewController = PlayerViewController.shared
    
    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var tvChannelImageView: UIImageView!

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sideMenuSegue", let destination = segue.destination as? UISideMenuNavigationController, let baseMenuVC = destination.children.first as? BaseSideMenuViewController{
            baseMenuVC.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSidemenuGestures()
        configureImageViewsLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.makeTransparent()
    }

    
    private func configureImageViewsLayer(){
        roundView(tvChannelImageView)
        roundView(radioImageView)
        borderView(tvChannelImageView)
        borderView(radioImageView)
    }
    
    private func roundView(_ view: UIView){
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }
    
    private func borderView(_ view: UIView){
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func configureSidemenuGestures() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuLeftNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    
    
    @IBAction func tvDidPressed(_ sender: Any) {
        playerViewController.playTV(in: self)
    }
    
    
    @IBAction func radioDidPressed(_ sender: Any) {
        playerViewController.playRadio(in: self)
    }
    
}

extension HomeViewController: SideMenuDelegate{
    func didSelectItem(at index: Int) {
        print(index)
    }
}

//MARK:- Social media buttons action
extension HomeViewController{
    //MARK:- IBActions
    fileprivate func openUrl(_ socialUrl: URL?) {
        if let url = socialUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func facebookDidPressed(_ sender: Any) {
        let facebookUrl = ApiManager.getFacebookUrl()
        openUrl(facebookUrl)
    }
    
    @IBAction func youtubeDidPressed(_ sender: Any) {
        let youtubeUrl = ApiManager.getYoutubeUrl()
        openUrl(youtubeUrl)
    }
    
    @IBAction func linkedinDidPressed(_ sender: Any) {
        let linkedinUrl = ApiManager.getLinkedinUrl()
        openUrl(linkedinUrl)
    }
    
    
    @IBAction func shareDidPressed(_ sender: Any) {
        
    }
}
//
//extension HomeViewController{
//    func checkError(for player: AVPlayer) {
//        // Get AVPlayerItem
//
//        // Get AVPlayer
//
//        // Add observer for AVPlayer status and AVPlayerItem status
//        player.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .initial], context: nil)
//        player.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options:[.new, .initial], context: nil)
//
//        // Watch notifications
//        let center = NotificationCenter.default
//        center.addObserver(self, selector: #selector(newErrorLogEntry(_:)), name: .AVPlayerItemNewErrorLogEntry, object: player.currentItem)
//        center.addObserver(self, selector: #selector(failedToPlayToEndTime(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: player.currentItem)
//    }
//
//    // Observe If AVPlayerItem.status Changed to Fail
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == #keyPath(AVPlayer.currentItem.status) {
//            let newStatus: AVPlayerItem.Status
//            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
//                newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue)!
//            } else {
//                newStatus = .unknown
//            }
//            if newStatus == .failed {
//                NSLog("Error: \(String(describing: player?.currentItem?.error?.localizedDescription)), error: \(String(describing: self.player?.currentItem?.error))")
//            }
//        }
//    }
//
//    // Getting error from Notification payload
//    @objc func newErrorLogEntry(_ notification: Notification) {
//        guard let object = notification.object, let playerItem = object as? AVPlayerItem else {
//            return
//        }
//        guard let errorLog: AVPlayerItemErrorLog = playerItem.errorLog() else {
//            return
//        }
//        NSLog("Error: \(errorLog)")
//    }
//
//    @objc func failedToPlayToEndTime(_ notification: Notification) {
//        let error = notification.userInfo!["AVPlayerItemFailedToPlayToEndTimeErrorKey"] as! Error
//        NSLog("Error: \(error.localizedDescription), error: \(error)")
//    }
//}
