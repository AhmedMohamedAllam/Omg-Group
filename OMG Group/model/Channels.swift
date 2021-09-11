//
//  Channels.swift
//  OMG Group
//
//  Created by Ahmed Allam on 11/09/2021.
//  Copyright © 2021 OMG Group. All rights reserved.
//

import Foundation

// MARK: - ChannelElement
struct Channel: Comparable, Codable {
   
    let id: Int?
    let nameAr, nameEn: String?
    let descAr, descEn: String?
    var tvURL: String?
    let background: String?
    let icon: String?
    let activeAds, activeLogo, activeImageAds, activeTime: Bool?
    let activeHashTag: Bool?
    let hashTag, createdAt, updatedAt: String?
    var order: Int?
    
    internal init(radioURL: String?) {
        self.tvURL = radioURL
        self.order = 1000
        
        self.id = nil
        self.nameAr = nil
        self.nameEn = nil
        self.descAr = nil
        self.descEn = nil
        self.background = nil
        self.icon = nil
        self.activeAds = nil
        self.activeLogo = nil
        self.activeImageAds = nil
        self.activeTime = nil
        self.activeHashTag = nil
        self.hashTag = nil
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descAr = "desc_ar"
        case descEn = "desc_en"
        case tvURL = "tv_url"
        case background, icon
        case activeAds = "active_ads"
        case activeLogo = "active_logo"
        case activeImageAds = "active_image_ads"
        case activeTime = "active_time"
        case activeHashTag = "active_hash_tag"
        case hashTag = "hash_tag"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case order
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        lhs.order ?? 0 < rhs.order ?? 0
    }
}

typealias Channels = [Channel]
