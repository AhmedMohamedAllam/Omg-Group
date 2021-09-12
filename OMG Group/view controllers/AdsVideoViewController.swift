//
//  AdsVideoViewController.swift
//  OMG Group
//
//  Created by Ahmed Allam on 12/09/2021.
//  Copyright © 2021 OMG Group. All rights reserved.
//

import UIKit
import Player
import ImageSlideshow

class AdsVideoViewController: UIViewController {
    
    
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet weak var topCloseButtonConstraint: NSLayoutConstraint!
    
    private lazy var apiManager = ApiManager()
    private var player: Player!
    private var shouldHideCloseButton = true
    
    var videoURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayer()
        configureTapGesture()
        closeButton.setTitle("", for: .normal)
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
        player.url = videoURL
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
    
}
