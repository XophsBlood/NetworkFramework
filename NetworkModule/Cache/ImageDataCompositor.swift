//
//  ImageDataCompositor.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 13.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class ImageDataCompositor: ImageDataLoader {
    let imageDataLoader: ImageDataLoader
    let localImageDataLoader: ImageDataLoader
    
    public init(imageDataLoader: ImageDataLoader, localImageDataLoader: ImageDataLoader) {
        self.imageDataLoader = imageDataLoader
        self.localImageDataLoader = localImageDataLoader
    }
    
    public func getImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTaskProtocol? {
        imageDataLoader.getImageData(with: url) { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case .failure(_):
                self.localImageDataLoader.getImageData(with: url, completion: completion)
            }
        }
        
    }
}
