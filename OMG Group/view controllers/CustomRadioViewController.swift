//
//  CustomRadioViewController.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/30/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import UIKit
import AVKit

class CustomRadioViewController: UIViewController {

    @IBOutlet weak var radioContainerView: UIView!
    @IBOutlet weak var pauseAndPlayButton: UIButton!
    
    var player: AVPlayer!
    var isPlaying = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addVideoPlayer(to: radioContainerView)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.pause()
        
    }
    
    @IBAction func pauseAndPlay(_ sender: Any) {
       updatePauseAndPlayButtonImage()
        if isPlaying{
            player.pause()
        }else{
            player.play()
        }
        isPlaying = !isPlaying
    }
    
    private func updatePauseAndPlayButtonImage(){
        let imageName = isPlaying ? "play" : "pause"
        let image = UIImage(named: imageName)
        pauseAndPlayButton.setImage(image, for: .normal)
    }
    
  
    
    func addVideoPlayer(to view: UIView) {
        let layer = PlayerViewController.shared.playerLayer!
        layer.player = player
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.sublayers?
            .filter { $0 is AVPlayerLayer }
            .forEach { $0.removeFromSuperlayer() }
        view.layer.addSublayer(layer)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
