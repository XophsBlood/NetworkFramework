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
        
        return imageDataLoader.getImageData(with: url, completion: completion)
    }
    
    
}
