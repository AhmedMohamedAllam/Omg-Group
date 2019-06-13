//
//  AppDelegate.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/28/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let apiManager = ApiManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //update Url from admin panel every time
        apiManager.updateUrls()
        //make splash screen wait two seconds
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2.0))
        //for  audio to work in background
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            print(error)
        }
        // This will enable to show nowplaying controls on lock screen
        application.beginReceivingRemoteControlEvents()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
            PlayerViewController.shared.removePlayer()
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
            PlayerViewController.shared.reAttatchPlayer()
    }

    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == UIEvent.EventType.remoteControl{
            if event?.subtype == UIEvent.EventSubtype.remoteControlTogglePlayPause{
                PlayerViewController.shared.togglePlayPause()
            }
        }
    }
    
}

