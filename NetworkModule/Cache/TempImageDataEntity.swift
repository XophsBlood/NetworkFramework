//
//  TempImageDataEntity.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 10.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class TempImagesDataEntity: Codable {
    var imagesData: [URL] = []
    let cacheTime: TimeInterval
    public var imagesResult: ImagesResult
    
    public init( cacheTime: TimeInterval, imagesResult: ImagesResult) {
        self.cacheTime = cacheTime
        self.imagesResult = imagesResult
    }
}
