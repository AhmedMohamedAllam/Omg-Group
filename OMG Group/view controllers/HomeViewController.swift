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
import GoogleMobileAds
import ImageSlideshow
import SafariServices
import Speakol

class HomeViewController: UIViewController {
    let playerViewController = PlayerViewController.shared
    
//    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var channelsCollectionView: UICollectionView!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var speakolViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var speakolCollectionView: SpeakolCollectionView!

    private lazy var apiManager = ApiManager()
    var channels: Channels = []
    var sliderImages: SliderImages = []
    var mainConfig: MainConfig?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private var currentIndex = -1
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sideMenuSegue", let destination = segue.destination as? UISideMenuNavigationController, let baseMenuVC = destination.children.first as? BaseSideMenuViewController{
            baseMenuVC.delegate = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        speakolCollectionView.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        speakolCollectionView.viewWillDisappear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSpeakol()
        configureChannelsCollectionView()
        configureSidemenuGestures()
        configureImageSliderTap()
        navigationController?.navigationBar.barStyle = .black
//        setupBannerView()
        fetchChannels()
        fetchMainConfig()
        fetchSliderImages()
//        hideSpeakolView()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.makeTransparent()
    }
    
    
//    private func setupBannerView(){
//        bannerView.adUnitID = "ca-app-pub-1001110363789350/6542589052"
//        bannerView.rootViewController = self
//        bannerView.delegate = self
//        bannerView.load(GADRequest())
//    }
    
    private func openUrl(_ socialUrl: URL?) {
        if let url = socialUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func openSafari(_ url: URL?){
        if let url = url{
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func configureSidemenuGestures() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuLeftNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    func share(url: URL) {
        let sharedObjects:[AnyObject] = [url as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func radioDidPressed(_ sender: Any) {
        presentCustomRadioView()
    }
    
    private func presentCustomRadioView(){
        let customRadioVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomRadioViewController") as! CustomRadioViewController
        let url = mainConfig?.radioURL ?? ""
        guard let radioURL = URL(string: url) else {
            showAlert(title: "Soething went wrong!", message: "Radio url is not valid!")
            return }
        customRadioVC.player = playerViewController.radioPlayer(url: radioURL)
        navigationController?.pushViewController(customRadioVC, animated: true)
    }
    
    private func playTV(channel: Channel){
        guard let tvURL = URL(string: channel.tvURL ?? "") else {
            showAlert(title: "Soething went wrong!", message: "Channel url is not valid!")
            return }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "VideoPlayerViewController") as? VideoPlayerViewController{
            vc.modalPresentationStyle = .fullScreen
            vc.videoUrl = tvURL
            vc.channel = channel
            present(vc, animated: true, completion: nil)
        }
//        PlayerViewController.shared.playTV(url: tvURL, in: self)
    }
    
    private func openAboutUs(){
        let url = ApiConstants.getAboutUsUrl()
        openUrl(url)
    }
    
    private func openAdvertiseWithUs(){
        let url = ApiConstants.getAdvertisingWithUsUrl()
        openUrl(url)
    }
    
    
    
}

//MARK:- Speakol ads
extension HomeViewController{
    func hideSpeakolView(){
        speakolViewConstraint.constant = 0
    }
    
    func showSpeakolView(){
        speakolViewConstraint.constant = 300
    }
}

extension HomeViewController: SpeakolCollectionViewDelegate, SpeakolCollectionViewDataSource, SpeakolCollectionViewDelegateFlowLayout{
    
    func configureSpeakol(){
        speakolCollectionView.speakolDelegate = self
        speakolCollectionView.speakolDataSource = self
        speakolCollectionView.speakolDelegateFlowLayout = self
    }
    
    func speakolCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
//        number_of_your_items_want_to_be_displayed // not the speakol items will be inserted in another section this section is used for the publisher items only
    }
    
    func speakolCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath)
        return cell
    }
    
    func speakolCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCellSize = collectionView.frame.size.width
        return CGSize(width: collectionCellSize, height: 300)
    }
}

//MARK:- Slider images
extension HomeViewController{
    func fetchSliderImages(){
        apiManager.getData(endpoint: .sliderImages, type: SliderImages.self) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
                case .success(let images):
                    self.sliderImages = images
                    self.updateSlider(self.sliderImages)
                case .failure(let error):
                    print(error)
                    self.showAlert(title: "Something went wrong!", message: "Please try agian later!")
            }
        }
    }
    
    func updateSlider(_ images: SliderImages?){
        let sliderImages = images?.compactMap{
            KingfisherSource(urlString: "\(ApiConstants.STORAGE_BASE_URL)\($0.image ?? "")")
        } ?? []
        imageSlider.setImageInputs(sliderImages)
        imageSlider.contentScaleMode = UIViewContentMode.scaleToFill
        imageSlider.slideshowInterval = Double(mainConfig?.sliderPeriod ?? 6)
        imageSlider.reloadInputViews()
    }
    
    func configureImageSliderTap(){
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageSlider))
        imageSlider.addGestureRecognizer(recognizer)
    }
    
    @objc
    func didTapImageSlider() {
        let currentPage = sliderImages[imageSlider.currentPage]
        guard let url = URL(string: currentPage.url ?? "") else {return}
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        openUrl(urlComponents?.url)
    }
}

//MARK:- MainConfiguration
extension HomeViewController{
    func fetchMainConfig(){
        apiManager.getData(endpoint: .mainConfiguration, type: MainConfig.self) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
                case .success(let config):
                    self.mainConfig = config
                    self.updateView(with: self.mainConfig)
                case .failure(let error):
                    print(error)
                    self.showAlert(title: "Something went wrong!", message: "Please try agian later!")
            }
        }
    }
    
    func updateView(with config: MainConfig?){
        guard let config = config else { return }
        topImageView.setImageKF(path: config.homeTopImage)
        backgroundImageView.setImageKF(path: config.appBackground)
    }
}

//MARK:- Side Menu
extension HomeViewController: SideMenuDelegate{
    
    func channelTitle(at index: Int) -> String? {
        if index < channels.count{
            return channels[index].nameEn ?? channels[index].nameAr
        }
        return nil
    }
    
    
    func didSelectSideMenuItem(at index: Int) {
        let firstIndexAfterArray = channels.count
        let secondIndexAfterArray = channels.count + 1
        switch index {
            case firstIndexAfterArray:
                openAboutUs()
            case secondIndexAfterArray:
                openAdvertiseWithUs()
            default:
                guard index < channels.count else { return }
                navigationController?.dismiss(animated: true, completion: nil)
                didSelectChannel(at: index)
        }
    }
}



extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func configureChannelsCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ((channelsCollectionView.frame.width) / 2) - 32 , height: 60)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        channelsCollectionView.collectionViewLayout = layout
        channelsCollectionView.delegate = self
        channelsCollectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "channelCell", for: indexPath)
        let imageView = cell.viewWithTag(792021) as? UIImageView
        let channel = channels[indexPath.row]
        imageView?.setImageKF(path: channel.icon)
        if indexPath.row == channels.count - 1{
            imageView?.image = UIImage(named: "custom-radio-small")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectChannel(at: indexPath.row)
    }
    
    func didSelectChannel(at index: Int){
        let radioIndex = channels.count - 1
        guard index != radioIndex else {
            presentCustomRadioView()
            return
        }
        let channel = channels[index]
        playTV(channel: channel)
    }
    
    func fetchChannels(){
        apiManager.getData(endpoint: .channels, type: Channels.self) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
                case .success(let channels):
                    self.channels = channels
                    self.channels.append(Channel(radioURL: self.mainConfig?.radioURL))
                    self.channels.sort()
                    self.updateChannels(channels)
                case .failure(let error):
                    print(error)
                    self.showAlert(title: "Something went wrong!", message: "Please try agian later!")
            }
        }
    }
    
    private func updateChannels(_ channels: Channels){
        channelsCollectionView.reloadData()
    }
    
}

//MARK:- Social media buttons action
extension HomeViewController{
    //MARK:- IBActions
    
    @IBAction func facebookDidPressed(_ sender: Any) {
        let facebookUrl = ApiConstants.getFacebookUrl()
        openUrl(facebookUrl)
    }
    
    @IBAction func instagramDidPressed(_ sender: Any) {
        let facebookUrl = ApiConstants.getInstagramUrl()
        openUrl(facebookUrl)
    }
    
    @IBAction func youtubeDidPressed(_ sender: Any) {
        let youtubeUrl = ApiConstants.getYoutubeUrl()
        openUrl(youtubeUrl)
    }
    
    @IBAction func linkedinDidPressed(_ sender: Any) {
        let linkedinUrl = ApiConstants.getLinkedinUrl()
        openUrl(linkedinUrl)
    }
    
    
    @IBAction func shareDidPressed(_ sender: Any) {
        share(url: ApiConstants.getAboutUsUrl())
    }
}
