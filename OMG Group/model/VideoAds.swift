//
//  VideoAds.swift
//  OMG Group
//
//  Created by Ahmed Allam on 11/09/2021.
//  Copyright © 2021 OMG Group. All rights reserved.
//

import Foundation
// MARK: - AdVideoElement
struct AdVideo: Codable {
    let id: Int?
    let name: String?
    let period: Int?
    let type: String?
    let videos: [VideoModel]?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, period, type, videos
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Video
struct VideoModel: Codable {
    let downloadLink, originalName: String?
    
    enum CodingKeys: String, CodingKey {
        case downloadLink = "download_link"
        case originalName = "original_name"
    }
}

typealias AdVideos = [AdVideo]
