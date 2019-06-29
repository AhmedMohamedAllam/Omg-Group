//
//  UrlPresistent.swift
//  OMG Group
//
//  Created by Ahmed Allam on 6/13/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import Foundation

struct UrlStorage {
    static func saveUrls(model: OmgUrl?) {
        saveUrl(url: model?.tvUrl(), for: .tv)
        saveUrl(url: model?.radioUrl(), for: .radio)
    }
    
    static func getUrl(for key: UrlType) -> URL? {
        return UserDefaults.standard.url(forKey: key.rawValue)
    }
    
    private static func saveUrl(url: URL?, for key: UrlType) {
        UserDefaults.standard.set(url, forKey: key.rawValue)
    }
    
   
}

enum UrlType: String{
    case radio
    case tv
}
