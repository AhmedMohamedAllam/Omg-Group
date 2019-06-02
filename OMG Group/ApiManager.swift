//
//  ApiManager.swift
//  OMG Group
//
//  Created by Ahmed Allam on 5/28/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import Foundation

struct ApiManager {
    
    static func getTVStreamUrl() -> URL{
        let urlString = "http://oohlivetv.co/live/omgtv/index.m3u8"
        return URL(string: urlString)!
    }
    
    static func getRadioStreamUrl() -> URL{
        let urlString = "http://oohlivetv.co/live/omgradio/index.m3u8"
        return URL(string: urlString)!
    }
    
    static func getFacebookUrl() -> URL{
        let urlString = "https://www.facebook.com/Omg-Channel-1687614811490132/"
        return URL(string: urlString)!
    }
    
    static func getYoutubeUrl() -> URL{
        let urlString = "https://m.youtube.com/channel/UCqc1YeG_iEwmrXVe4wPUhTg"
        return URL(string: urlString)!
    }
    
    static func getLinkedinUrl() -> URL{
        let urlString = "https://www.linkedin.com/company/omg-channel"
        return URL(string: urlString)!
    }
    
    static func getAboutUsUrl() -> URL{
        let urlString = "http://omgchannel.net/OMG/About-Us"
        return URL(string: urlString)!
    }
    
    static func getAdvertisingWithUsUrl() -> URL{
        let urlString = "http://omgchannel.net/OMG?journal_blog_post_id=75"
        return URL(string: urlString)!
    }
    
    
}
