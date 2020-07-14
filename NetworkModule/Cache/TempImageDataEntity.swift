//
//  TempImageDataEntity.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 10.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

class TempImagesDataEntity: Codable {
    var imagesData: [URL] = []
    let cacheTime: TimeInterval
    var imagesResult: ImagesResult
    
    init( cacheTime: TimeInterval, imagesResult: ImagesResult) {
        self.cacheTime = cacheTime
        self.imagesResult = imagesResult
    }
}
