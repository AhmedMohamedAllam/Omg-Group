//
//  AdImageModel.swift
//  OMG Group
//
//  Created by Ahmed Allam on 11/09/2021.
//  Copyright © 2021 OMG Group. All rights reserved.
//

import Foundation
typealias AdImagesArray = [AdImages]

struct AdImages: Codable {
    let id: Int?
    let name: String?
    let images: [String]?
    let type: String?
    let period: Int?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, images, type, period
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

