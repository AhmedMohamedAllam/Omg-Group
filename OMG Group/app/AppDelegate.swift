//
//  AppDelegate.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/28/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import Speakol

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureSpeakol()
        
        //start mobile ads
        GADMobileAds.sharedInstance().start(completionHandler: nil)
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
    
    private func configureSpeakol(){
        SpeakolManager.shared.speakolToken = "ae3a12e662884604c069b4dfc5a13afd"
        SpeakolManager.shared.widgetId = "wi-8395"
        SpeakolManager.shared.initializeSpeakolWithToken()
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

