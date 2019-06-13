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
    
    
    func reAttatchPlayer() {
        playerLayer.player = currentRadioPlayer
    }
    
    func removePlayer(){
        playerLayer.player = nil
    }
    
    //play tv in full screen
    func playTV(in viewcontroller: UIViewController) {
        play(with: tvPlayer(), in: viewcontroller)
    }
    
    //play radio in full screen
    func playRadio(in viewcontroller: UIViewController) {
        play(with: radioPlayer(), in: viewcontroller)
    }
    
    
    private func tvPlayer() -> AVPlayer{
        let tvUrl = ApiConstants.getTVStreamUrl()
        return AVPlayer(url: tvUrl)
    }
    
    
    func radioPlayer() -> AVPlayer{
        let radioUrl = ApiConstants.getRadioStreamUrl()
        setNowPlayingInfo()
        currentRadioPlayer = AVPlayer(url: radioUrl)
        addPlayCommandCenter()
        addPauseCommandCenter()
        return currentRadioPlayer!
    }
    
    
    private func play(with player: AVPlayer, in viewController: UIViewController) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        player.allowsExternalPlayback = true
        viewController.present(playerViewController, animated: true){
            DispatchQueue.main.async {
                player.play()
            }
        }
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
    
    private func addPlayCommandCenter(){
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        remoteCommandCenter.playCommand.addTarget { [unowned self] event -> MPRemoteCommandHandlerStatus in
            if self.currentRadioPlayer?.rate == 0.0{
                self.currentRadioPlayer?.play()
                self.sendPlayNotification()
                return .success
            }
            return .commandFailed
        }
    }
    
    private func addPauseCommandCenter(){
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        remoteCommandCenter.pauseCommand.addTarget { [unowned self] event -> MPRemoteCommandHandlerStatus in
            if self.currentRadioPlayer?.rate == 1.0{
                self.currentRadioPlayer?.pause()
                self.sendPauseNotification()
                return .success
            }
            return .commandFailed
        }
    }
    
    func togglePlayPause(){
        guard let player = currentRadioPlayer else {return}
        if player.rate == 0.0{
            player.play()
            sendPlayNotification()
        }else{
            player.pause()
            sendPauseNotification()
        }
    }
    
    private func sendPlayNotification(){
        NotificationCenter.default.post(name: .radioDidPlay, object: nil)
    }
    
    private func sendPauseNotification(){
        NotificationCenter.default.post(name: .radioDidPause, object: nil)
    }
}


