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
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var tvChannelImageView: UIImageView!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSidemenuGestures()
        configureImageViewsLayer()
        configureShareButtonsLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.makeTransparent()
    }
    
    private func configureShareButtonsLayer(){
        roundView(facebookButton)
        roundView(shareButton)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sideMenuSegue", let destination = segue.destination as? UISideMenuNavigationController, let baseMenuVC = destination.children.first as? BaseSideMenuViewController{
            baseMenuVC.delegate = self
        }
    }
    
    private func presentStream(with url: URL){
        setNowPlayingInfo()
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
    
    func setNowPlayingInfo()
    {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        let title = "Omg radio"
        let album = "Omg Album"
        let artworkData = Data()
        let image = UIImage(data: artworkData) ?? UIImage()
        let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: {  (_) -> UIImage in
            return image
        })
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = album
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

    
    
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
    
    @IBAction func tvDidPressed(_ sender: Any) {
        let tvUrl = ApiManager.getTVStreamUrl()
        presentStream(with: tvUrl)
    }
    
    
    @IBAction func radioDidPressed(_ sender: Any) {
        let radioUrl = ApiManager.getRadioStreamUrl()
        presentStream(with: radioUrl)
    }
    
}

extension HomeViewController: SideMenuDelegate{
    func didSelectItem(at index: Int) {
        print(index)
    }
}


extension HomeViewController{
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
