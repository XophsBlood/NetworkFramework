//
//  ImageDetailsResult.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 26.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

struct ImageDetailsResult: Codable {
    let author: String
    let camera: String
    let croppedPicture: String
    let fullPicture: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case croppedPicture = "cropped_picture"
        case fullPicture = "full_picture"
        case author = "author"
        case camera = "camera"
        case id = "id"
    }
}
