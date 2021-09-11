//
//  Endpoint.swift
//  OMG Group
//
//  Created by Ahmed Allam on 11/09/2021.
//  Copyright © 2021 OMG Group. All rights reserved.
//

import Foundation

enum Endpoint {
    case adsImages
    case sliderImages
    case videoAds
    case mainConfiguration
    case channels
    
    var url: String{
        switch self {
            case .adsImages:
                return "api/image-ads"
            case .sliderImages:
                return "api/sliders"
            case .videoAds:
                return "api/lists"
            case .mainConfiguration:
                return "api/tv-radio-urls"
            case .channels:
                return "api/channels"
        }
    }
}
