//
//  TokenLoader.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 24.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class HTTPTokenLoader: TokenLoader {
    let httpClient: HTTPClient
    init(httpCLient: HTTPClient) {
        self.httpClient = httpCLient
    }
    public func auth(with url: URL, params: [String: String], completion: @escaping (Swift.Result<AuthResult, Error>) -> ()) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = try! JSONEncoder().encode(params)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        httpClient.get(from: urlRequest) { result in
            switch result {
            case let .success(data, _):
                if let authResult: AuthResult = try? JSONDecoder().decode(AuthResult.self, from: data) {
                    completion(.success(authResult))
                    if let token = authResult.token {
                        AuthHTTPClient.token = token
                    } else {
                        completion(.failure(UnexpectedError.unexpected))
                    }
                    
                } else {
                    completion(.failure(UnexpectedError.unexpected))
                }
            case let .failure(error):
                completion(.failure(error))
            }
            
        }
    }
    
}
