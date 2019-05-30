//
//  PlayerViewController.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/29/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import AVKit
import MediaPlayer

class PlayerViewController {
    static let shared = PlayerViewController()
    var playerViewController: AVPlayerViewController!
    var currentRadioPlayer: AVPlayer?
    
    private init() {
        playerViewController = AVPlayerViewController()
    }
    
    func play(with player: AVPlayer, in viewController: UIViewController) {
        playerViewController.player = player
        player.allowsExternalPlayback = true
        viewController.present(playerViewController, animated: true){
            DispatchQueue.main.async {
                player.play()
            }
        }
    }
    func reAttatchPlayer() {
        playerViewController.player = currentRadioPlayer
    }
    
    func removePlayer(){
        playerViewController.player = nil
    }
    
    func playTV(in viewcontroller: UIViewController) {
        presentStream(player: tvPlayer(), in: viewcontroller)
    }
    
    func playRadio(in viewcontroller: UIViewController) {
        presentStream(player: radioPlayer(), in: viewcontroller)
    }
    
    func setRadioPlaying(isPlaying: Bool){
        UserDefaults.standard.set(isPlaying, forKey: "radioIsPlaying")
    }
    
    func radioIsPlaying() -> Bool{
        return UserDefaults.standard.bool(forKey:"radioIsPlaying")
    }
    
    private func tvPlayer() -> AVPlayer{
        let tvUrl = ApiManager.getTVStreamUrl()
        return AVPlayer(url: tvUrl)
    }
    
    private func radioPlayer() -> AVPlayer{
        let radioUrl = ApiManager.getRadioStreamUrl()
        currentRadioPlayer = AVPlayer(url: radioUrl)
        return currentRadioPlayer!
    }
    
    private func presentStream(player: AVPlayer, in viewController: UIViewController){
        setNowPlayingInfo()
        play(with: player, in: viewController)
    }
    
    
    
    private func setNowPlayingInfo(){
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
}

