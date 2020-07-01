//
//  ImagesResult.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 26.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public struct ImagesResult: Codable {
    public let hasMore: Bool
    public let page: Int
    public let pageCount: Int
    public let pictures: [MyPicture]
    
    public init(hasMore: Bool, page: Int, pageCount: Int, pictures: [MyPicture]) {
        self.hasMore = hasMore
        self.page = page
        self.pageCount = pageCount
        self.pictures = pictures
    }
}

public struct MyPicture: Codable {
    public let croppedPictrure: String
    public let id: String
    
    enum CodingKeys: String, CodingKey {
      case croppedPictrure = "cropped_picture"
      case id = "id"
    }
    
    public init(croppedPictrure: String, id: String) {
        self.croppedPictrure = croppedPictrure
        self.id = id
    }
    
}
