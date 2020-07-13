//
//  HTTPImagesLoader.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 24.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class HTTPImagesLoader: ImagesLoader {
    
    let httpClient: HTTPClient
    let localImageDataLoader: LocalImageDataLoader
    
    public init(httpCLient: HTTPClient, localImageDataLoader: LocalImageDataLoader) {
        self.localImageDataLoader = localImageDataLoader
        self.httpClient = httpCLient
    }
    
    public func getImages(with url: URL, completion: @escaping (Result<ImagesResult, Error>) -> ()) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        httpClient.get(from: urlRequest) { result in
            switch result {
            case let .success(data, _):
                if let imagesResult: ImagesResult = try? JSONDecoder().decode(ImagesResult.self, from: data) {
                    print(imagesResult.pictures)
                    if let pageNumber = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value {
                        let imagesCacheEntity = TempImagesDataEntity(cacheTime: Date().timeIntervalSinceReferenceDate, imagesResult: imagesResult)
                        let data = try? JSONEncoder().encode(imagesCacheEntity)
                        // self.localImageDataLoader.store.clearCache(page: pageNumber)
                        self.localImageDataLoader.store.saveMain(data: data!, page: pageNumber)
                    } else {
                        let imagesCacheEntity = TempImagesDataEntity(cacheTime: Date().timeIntervalSinceReferenceDate, imagesResult: imagesResult)
                        let data = try? JSONEncoder().encode(imagesCacheEntity)
                        // self.localImageDataLoader.store.clearCache(page: "1")
                        self.localImageDataLoader.store.saveMain(data: data!, page : "1")
                    }
                    

                    
                    completion(.success(imagesResult))
                } else {
                    completion(.failure(UnexpectedError.unexpected))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> Int? {
      guard let url = URLComponents(string: url) else { return nil }
        return Int((url.queryItems?.first(where: { $0.name == param })?.value)!)
    }
}
