//
//  ImagesFeedCompositor.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 13.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class ImagesFeedCompositor: ImagesLoader {
    
    let imagesLoader: ImagesLoader
    let localImageDataLoader: ImagesLoader
    
    public init(imagesLoader: ImagesLoader, localImageDataLoader: ImagesLoader) {
        self.imagesLoader = imagesLoader
        self.localImageDataLoader = localImageDataLoader
    }
    
    public func getImages(with url: URL, completion: @escaping (Result<ImagesResult, Error>) -> ()) {
        imagesLoader.getImages(with: url) { result in
            switch result {
            case let .success(imagesResult):
                completion(.success(imagesResult))
            case .failure(_):
                self.localImageDataLoader.getImages(with: url, completion: completion)
            }
        }
    }
}
