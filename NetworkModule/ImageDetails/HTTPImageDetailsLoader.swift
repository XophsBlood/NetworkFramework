//
//  HTTPImageDetailsLoader.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 26.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

class HTTPImageDetailsLoader: ImageDetailsLoader {
    let httpClient: HTTPClient
    
    init(httpCLient: HTTPClient) {
        self.httpClient = httpCLient
    }
    
    func getImageDetails(with url: URL, completion: @escaping (Result<ImageDetailsResult, Error>) -> ()) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        httpClient.get(from: urlRequest) { result in
            switch result {
            case let .success(data, _):
                if let imageDetailsResult: ImageDetailsResult = try? JSONDecoder().decode(ImageDetailsResult.self, from: data) {
                    completion(.success(imageDetailsResult))
                } else {
                    completion(.failure(UnexpectedError.unexpected))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        }
    }
}
