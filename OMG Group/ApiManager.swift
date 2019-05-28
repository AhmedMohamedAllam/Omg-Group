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
        let urlString =
//        "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
//        "https://www.radiantmediaplayer.com/media/bbb-360p.mp4"
        "http://media6.smc-host.com:1935/omgchannel.net/omgtv/playlist.m3u8"
        return URL(string: urlString)!
    }
    
    static func getRadioStreamUrl() -> URL{
        let urlString = "http://media6.smc-host.com:1935/omgchannel.net/omgtv/playlist.m3u8"
        return URL(string: urlString)!
    }
}
