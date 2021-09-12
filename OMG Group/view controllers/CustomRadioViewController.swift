//
//  CustomRadioViewController.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/30/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import UIKit
import AVKit
import GoogleMobileAds
import Speakol

class CustomRadioViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var radioContainerView: UIView!
    @IBOutlet weak var pauseAndPlayButton: UIButton!
    
    @IBOutlet weak var wavesImageView: UIImageView!
    @IBOutlet weak var worldListenLabel: UILabel!
    @IBOutlet weak var speakolTableView: SpeakolTableView!

    var player: AVPlayer!
    var isPlaying = true{
        didSet{
            updatePauseAndPlayButtonImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSpeakolTableView()

        addVideoPlayer(to: radioContainerView)
        registerForPlayAndPause()
        playWavesGif()
        setupBannerView()
    }
    
    func configureSpeakolTableView(){
        speakolTableView.speakolDelegate = self
        speakolTableView.speakolDataSource = self
        speakolTableView.numberOfAds = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        speakolTableView.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        speakolTableView.viewWillDisappear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.pause()
    }
    
    
    private func setupBannerView(){
        bannerView.adUnitID = "ca-app-pub-1001110363789350/6542589052"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    @IBAction func pauseAndPlay(_ sender: Any) {
        if isPlaying{
            player.pause()
        }else{
            player.play()
        }
        isPlaying = !isPlaying
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    private func playWavesGif(){
        wavesImageView.loadGif(name: "waves")
    }
    
    private func updatePauseAndPlayButtonImage(){
        let imageName = isPlaying ? "pause" : "play"
        let image = UIImage(named: imageName)
        pauseAndPlayButton.setImage(image, for: .normal)
        wavesImageView.isHidden = !isPlaying
    }
    
    private func registerForPlayAndPause() {
        NotificationCenter.default.addObserver(forName: .radioDidPlay, object: nil, queue: nil) { [weak self] (notification) in
            self?.isPlaying = true
        }
        
        NotificationCenter.default.addObserver(forName: .radioDidPause, object: nil, queue: nil) { [weak self] (notification) in
            self?.isPlaying = false
        }
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

extension CustomRadioViewController: SpeakolTableViewDelegate, SpeakolTableViewDataSource{
    func speakolTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
            //        number_of_your_items_want_to_be_displayed // not the speakol items will be inserted in another section this section is used for the publisher items only
    }
    
func speakolTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // here you will return the any tableview cell you want to dispaly
    let cell = speakolTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    return cell
}
}
