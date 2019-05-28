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
        let urlString = "http://media6.smc-host.com:1935/omgchannel.net/omgtv/playlist.m3u8"
        return URL(string: urlString)!
    }
    
    static func getRadioStreamUrl() -> URL{
        let urlString = "http://account30.livebox.co.in/oohlivetvhls/live.m3u8"
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
    
    
}
