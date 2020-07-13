//
//  HTTPImageDataLoader.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 29.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class HTTPImageDataLoader: ImageDataLoader {
    let httpClient: HTTPClient
    let localImageDataLoader: LocalImageDataLoader
    
    public init(httpCLient: HTTPClient, localImageDataLoader: LocalImageDataLoader) {
        self.httpClient = httpCLient
        self.localImageDataLoader = localImageDataLoader
    }
    
    public func getImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTaskProtocol? {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return httpClient.get(from: urlRequest) { result in
            switch result {
            case let .success(data, _):
                if let pageNumber = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value {
                    if let mainCacheData = self.localImageDataLoader.store.getMainCacheData(page: pageNumber), let tempImagesDataEntity = try? JSONDecoder().decode(TempImagesDataEntity.self, from: mainCacheData) {
                        let temp = tempImagesDataEntity
                        temp.imagesData.append(url)
                        if let newData = try? JSONEncoder().encode(temp) {
                            self.localImageDataLoader.store.saveMain(data: newData, page: pageNumber)
                        }
                    }
                }
                self.localImageDataLoader.cache(with: url, and: data)
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }

        }
    }
}
