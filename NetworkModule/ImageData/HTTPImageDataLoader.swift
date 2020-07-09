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
    
    public init(httpCLient: HTTPClient) {
        self.httpClient = httpCLient
    }
    
    public func getImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTaskProtocol {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return httpClient.get(from: urlRequest) { result in
            switch result {
            case let .success(data, _):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }

        }
    }
}
