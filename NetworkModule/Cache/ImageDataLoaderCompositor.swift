//
//  ImageDataLoaderCompositor.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class ImageDataLoaderCompositor: ImageDataLoader {
    
    let imageDataLoader: ImageDataLoader
    let localImageDataLoader: LocalImageDataLoader
    
    public init(imageDataLoader: ImageDataLoader, localImageDataLoader: LocalImageDataLoader) {
        self.imageDataLoader = imageDataLoader
        self.localImageDataLoader = localImageDataLoader
    }
    
    public func getImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTaskProtocol? {
        
        if let data = localImageDataLoader.store.getData(with: url) {
            completion(.success(data))
            return nil
        }
        
        return imageDataLoader.getImageData(with: url) { result in
            switch result {
            case let .success(data):
                if let pageNumber = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value,
                    let mainCacheData = self.localImageDataLoader.store.getMainCacheData(page: pageNumber),
                    let tempImagesDataEntity = try? JSONDecoder().decode(TempImagesDataEntity.self, from: mainCacheData) {
                    let temp = tempImagesDataEntity
                    temp.imagesData.append(url)
                    if let newData = try? JSONEncoder().encode(temp) {
                        self.localImageDataLoader.store.saveMain(data: newData, page: pageNumber)
                    }
                }
                self.localImageDataLoader.cache(with: url, and: data)
                completion(.success(data))
            case .failure(_):
                break
            }
            
            
        }
    }
    
    
}
