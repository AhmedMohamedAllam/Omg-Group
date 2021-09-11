//
//  MainConfig.swift
//  OMG Group
//
//  Created by Ahmed Allam on 11/09/2021.
//  Copyright © 2021 OMG Group. All rights reserved.
//

import Foundation
struct MainConfig: Codable {
    let tvURL, radioURL: String?
    let appBackground: String?
    let ads, activeLogo, activeImageAds, activeTime: Bool?
    let activeHashTag: Bool?
    let hashtag, homeTopImage: String?
    let sliderPeriod: Int?
    
    enum CodingKeys: String, CodingKey {
        case tvURL = "tv_url"
        case radioURL = "radio_url"
        case appBackground = "app_background"
        case ads
        case activeLogo = "active_logo"
        case activeImageAds = "active_image_ads"
        case activeTime = "active_time"
        case activeHashTag = "active_hash_tag"
        case hashtag
        case homeTopImage = "home_top_image"
        case sliderPeriod = "slider_period"
    }
}
