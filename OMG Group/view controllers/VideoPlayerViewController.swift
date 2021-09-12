//
//  VideoPlayerViewController.swift
//  OMG Group
//
//  Created by Ahmed Allam on 12/09/2021.
//  Copyright © 2021 OMG Group. All rights reserved.
//

import UIKit
import Player
import ImageSlideshow

class VideoPlayerViewController: UIViewController {
    
    

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var hashtagLabel: UILabel!
    @IBOutlet private weak var clockLabel: UILabel!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var topCloseButtonConstraint: NSLayoutConstraint!

    private var adImages: AdImages?
    private lazy var apiManager = ApiManager()
    private var timer: Timer!
    private var player: Player!
    private var shouldHideCloseButton = true
    
    var videoUrl: URL?
    var channel: Channel?

    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayer()
        configureTapGesture()
        fetchSliderImages()
        closeButton.setTitle("", for: .normal)
        updateOverlaysAccordingToConfigFromAdminPanel()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(updateTime) , userInfo: nil, repeats: true)
        logoImageView.setImageKF(path: channel?.icon)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        autoHideCloseButton()
    }
    
    func configureTapGesture(){
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapVideo))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc
    func didTapVideo() {
        changeCloseButtonStatus(!shouldHideCloseButton)
    }
    
    func autoHideCloseButton(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.changeCloseButtonStatus(true)
        }
    }
    
    func changeCloseButtonStatus(_ isHiddden: Bool){
        if !isHiddden {autoHideCloseButton()}
        shouldHideCloseButton = isHiddden
        updateImageSliderAdsPosition()
    }
    
    func updateImageSliderAdsPosition(){
        let height: CGFloat = closeButton.frame.height
        self.topCloseButtonConstraint.constant = shouldHideCloseButton ? -height : 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutSubviews()
        }
    }
    
    private func addPlayer(){
        self.player = Player()
        player.fillMode = .resizeAspectFill
        player.url = videoUrl
        player.autoplay = true
        player.playerDelegate = self
        player.playbackDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        player.view.frame = view.bounds
        addChild(player)
        videoView.addSubview(player.view)
        player.didMove(toParent: self)
        player.playFromCurrentTime()
    }
    
    @IBAction private func didTapClose(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    func fetchSliderImages(){
        apiManager.getData(endpoint: .adsImages, type: AdImagesArray.self) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
                case .success(let images):
                    self.adImages = images.first(where: { ad in
                        ad.id == 8
                    })
                    self.updateSlider(self.adImages)
                case .failure(let error):
                    print(error)
                    self.showAlert(title: "Something went wrong!", message: "Please try agian later!")
            }
        }
    }
    
    func updateSlider(_ ad: AdImages?){
        let sliderImages = ad?.images?.compactMap{
            KingfisherSource(urlString: "\(ApiConstants.STORAGE_BASE_URL)\($0)")
        } ?? []
        imageSlider.setImageInputs(sliderImages)
        imageSlider.contentScaleMode = UIViewContentMode.scaleToFill
        imageSlider.pageIndicator = nil
        imageSlider.slideshowInterval = Double(ad?.period ?? 6)
        imageSlider.reloadInputViews()
    }
    
    func updateOverlaysAccordingToConfigFromAdminPanel(){
        hashtagLabel.isHidden = !(channel?.activeHashTag ?? false)
        hashtagLabel.text = channel?.hashTag
        clockLabel.isHidden = !(channel?.activeTime ?? false)
        imageSlider.isHidden = !(channel?.activeImageAds ?? false)
        logoImageView.isHidden = !(channel?.activeLogo ?? false)
    }
    
    
    @objc func updateTime() {
        clockLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
    }
    
}

extension VideoPlayerViewController: PlayerDelegate {
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    
}

extension VideoPlayerViewController: PlayerPlaybackDelegate {
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    public func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    public func playerPlaybackDidEnd(_ player: Player) {
    }
    
    public func playerCurrentTimeDidChange(_ player: Player) {
    }
    
    public func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
}
