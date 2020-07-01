//
//  ImageDetailsResult.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 26.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public struct ImageDetailsResult: Codable {
    
    public let author: String
    public let camera: String
    public let croppedPicture: String
    public let fullPicture: String
    public let id: String
    
    enum CodingKeys: String, CodingKey {
        case croppedPicture = "cropped_picture"
        case fullPicture = "full_picture"
        case author = "author"
        case camera = "camera"
        case id = "id"
    }
    
    public init(author: String, camera: String, croppedPicture: String, fullPicture: String, id: String) {
        self.author = author
        self.camera = camera
        self.croppedPicture = croppedPicture
        self.fullPicture = fullPicture
        self.id = id
    }
}
