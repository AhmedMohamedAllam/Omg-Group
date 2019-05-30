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
    var playerLayer: AVPlayerLayer!
    var currentRadioPlayer: AVPlayer?
    
    private init() {
        playerLayer = AVPlayerLayer(player: currentRadioPlayer)
    }
    
    func play(with player: AVPlayer, in viewController: UIViewController) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        player.allowsExternalPlayback = true
        viewController.present(playerViewController, animated: true){
            DispatchQueue.main.async {
                player.play()
            }
        }
    }
    func reAttatchPlayer() {
        playerLayer.player = currentRadioPlayer
    }
    
    func removePlayer(){
        playerLayer.player = nil
    }
    
    func playTV(in viewcontroller: UIViewController) {
        presentStream(player: tvPlayer(), in: viewcontroller)
    }
    
    func playRadio(in viewcontroller: UIViewController) {
        presentStream(player: radioPlayer(), in: viewcontroller)
    }
    
    private func tvPlayer() -> AVPlayer{
        let tvUrl = ApiManager.getTVStreamUrl()
        return AVPlayer(url: tvUrl)
    }
    
    func radioPlayer() -> AVPlayer{
        let radioUrl = ApiManager.getRadioStreamUrl()
        setNowPlayingInfo()
        currentRadioPlayer = AVPlayer(url: radioUrl)
        return currentRadioPlayer!
    }
    
    private func presentStream(player: AVPlayer, in viewController: UIViewController){
        play(with: player, in: viewController)
    }
    
    
    
    private func setNowPlayingInfo(){
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        let title = "Omg radio"
        let album = "<< live now >>"
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

