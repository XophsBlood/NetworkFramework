//
//  ImagesFeedLoaderCompositor.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 13.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class ImagesFeedLoaderDecorator: ImagesLoader {
    let imagesLoader: ImagesLoader
    let localImageDataLoader: LocalImageDataLoader
    
    public init(imagesLoader: ImagesLoader, localImageDataLoader: LocalImageDataLoader) {
        self.imagesLoader = imagesLoader
        self.localImageDataLoader = localImageDataLoader
    }
    
    public func getImages(with url: URL, completion: @escaping (Result<ImagesResult, Error>) -> ()) {
        
        imagesLoader.getImages(with: url) { result in
            switch result {
            case let .success(imagesResult):
                self.localImageDataLoader.saveMain(imagesResult: imagesResult)
                completion(.success(imagesResult))
            case .failure(_):
                self.localImageDataLoader.getImages(with: url, completion: completion)
            }
        }
    }
    
}


