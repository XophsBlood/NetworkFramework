//
//  ImagesResult.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 26.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

struct ImagesResult: Codable {
    let hasMore: Bool
    let page: Int
    let pageCount: Int
    let pictures: [Picture]
}

struct Picture: Codable {
    let croppedPictrure: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
      case croppedPictrure = "cropped_picture"
      case id = "id"
    }
    
    
}
