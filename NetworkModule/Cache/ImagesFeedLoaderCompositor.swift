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
        let pageNumber = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value ?? "1"
        
        if localImageDataLoader.store.chechExpirationDate(page: pageNumber), let mainCacheData = localImageDataLoader.store.getMainCacheData(page: pageNumber), let tempEntity = try? JSONDecoder().decode(TempImagesDataEntity.self, from: mainCacheData) {
                        completion(.success(tempEntity.imagesResult))
                        return
        
        }
        
        
        imagesLoader.getImages(with: url) { result in
            switch result {
            case let .success(imagesResult):
                let imagesCacheEntity = TempImagesDataEntity(cacheTime: Date().timeIntervalSinceReferenceDate, imagesResult: imagesResult)
                let data = try? JSONEncoder().encode(imagesCacheEntity)
                self.localImageDataLoader.store.clearCache(page: pageNumber)
                self.localImageDataLoader.store.saveMain(data: data!, page: pageNumber)
            case .failure(_):
                break
            }
        }
    }
    
}
