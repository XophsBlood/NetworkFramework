//
//  ImagesFeedLoaderCompositor.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 13.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class ImagesFeedLoaderCompositor: ImagesLoader {
    let imagesLoader: ImagesLoader
    let localImageDataLoader: LocalImageDataLoader
    
    public init(imagesLoader: ImagesLoader, localImageDataLoader: LocalImageDataLoader) {
        self.imagesLoader = imagesLoader
        self.localImageDataLoader = localImageDataLoader
    }
    
    public func getImages(with url: URL, completion: @escaping (Result<ImagesResult, Error>) -> ()) {
        
        if let pageNumber = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value, localImageDataLoader.store.chechExpirationDate(page: pageNumber) {
            
            if let mainCacheData = localImageDataLoader.store.getMainCacheData(page: pageNumber), let tempEntity = try? JSONDecoder().decode(TempImagesDataEntity.self, from: mainCacheData) {
                    completion(.success(tempEntity.imagesResult))
                    return
    
            }
        } else if URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value == nil, localImageDataLoader.store.chechExpirationDate(page: "1") {
            
            if let mainCacheData = localImageDataLoader.store.getMainCacheData(page: "1"), let tempEntity = try? JSONDecoder().decode(TempImagesDataEntity.self, from: mainCacheData) {
                            completion(.success(tempEntity.imagesResult))
                            return
            
                    }
        }
        
        imagesLoader.getImages(with: url, completion: completion)
    }
    
}
