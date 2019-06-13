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

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private var currentIndex = -1
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sideMenuSegue", let destination = segue.destination as? UISideMenuNavigationController, let baseMenuVC = destination.children.first as? BaseSideMenuViewController{
            baseMenuVC.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSidemenuGestures()
        configureImageViewsLayer()
        navigationController?.navigationBar.barStyle = .black
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
    
    private func openUrl(_ socialUrl: URL?) {
        if let url = socialUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func configureSidemenuGestures() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuLeftNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    func share(url: URL) {
        let sharedObjects:[AnyObject] = [url as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func tvDidPressed(_ sender: Any) {
        playerViewController.playTV(in: self)
    }
    
    
    @IBAction func radioDidPressed(_ sender: Any) {
        presentCustomRadioView()
    }
    
    private func presentCustomRadioView(){
        let customRadioVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomRadioViewController") as! CustomRadioViewController
        customRadioVC.player = playerViewController.radioPlayer()
        navigationController?.pushViewController(customRadioVC, animated: true)
    }
    
    private func openAboutUs(){
        let url = ApiConstants.getAboutUsUrl()
        openUrl(url)
    }
    
    private func openAdvertiseWithUs(){
        let url = ApiConstants.getAdvertisingWithUsUrl()
        openUrl(url)
    }
    
}

extension HomeViewController: SideMenuDelegate{
    func didSelectItem(at index: Int) {
        switch index {
        case 0:
            navigationController?.dismiss(animated: true, completion: nil)
            playerViewController.playTV(in: self)
        case 1:
            navigationController?.dismiss(animated: true, completion: nil)
            presentCustomRadioView()
        case 2:
            openAboutUs()
        case 3:
            openAdvertiseWithUs()
        default:
            print("Not found")
        }
    }
}

//MARK:- Social media buttons action
extension HomeViewController{
    //MARK:- IBActions
    
    
    @IBAction func facebookDidPressed(_ sender: Any) {
        let facebookUrl = ApiConstants.getFacebookUrl()
        openUrl(facebookUrl)
    }
    
    @IBAction func youtubeDidPressed(_ sender: Any) {
        let youtubeUrl = ApiConstants.getYoutubeUrl()
        openUrl(youtubeUrl)
    }
    
    @IBAction func linkedinDidPressed(_ sender: Any) {
        let linkedinUrl = ApiConstants.getLinkedinUrl()
        openUrl(linkedinUrl)
    }
    
    
    @IBAction func shareDidPressed(_ sender: Any) {
        share(url: ApiConstants.getAboutUsUrl())
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
