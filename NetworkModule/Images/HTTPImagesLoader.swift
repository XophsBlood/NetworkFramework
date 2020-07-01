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
    
    public init(httpCLient: HTTPClient) {
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
                    completion(.success(imagesResult))
                } else {
                    completion(.failure(UnexpectedError.unexpected))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        }
    }
}
