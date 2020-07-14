//
//  ImageDataLoaderCompositor.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class ImageDataLoaderDecorator: ImageDataLoader {
    
    let imageDataLoader: ImageDataLoader
    let localImageDataLoader: LocalImageDataLoader
    
    public init(imageDataLoader: ImageDataLoader, localImageDataLoader: LocalImageDataLoader) {
        self.imageDataLoader = imageDataLoader
        self.localImageDataLoader = localImageDataLoader
    }
    
    public func getImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTaskProtocol? {
        
        return imageDataLoader.getImageData(with: url) { result in
            switch result {
            case let .success(data):
                self.localImageDataLoader.cache(with: url, and: data)
                completion(.success(data))
            case .failure(_):
                self.localImageDataLoader.getImageData(with: url, completion: completion)
            }
            
            
        }
    }
    
    
}
