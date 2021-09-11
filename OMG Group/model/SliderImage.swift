//
//  SliderImage.swift
//  OMG Group
//
//  Created by Ahmed Allam on 11/09/2021.
//  Copyright © 2021 OMG Group. All rights reserved.
//

import Foundation

struct SliderImage: Codable {
    let id: Int?
    let name, createdAt, updatedAt, image: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case image, url
    }
}

typealias SliderImages = [SliderImage]
