//
//  AuthHTTPClient.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 24.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class AuthHTTPClient: HTTPClient {
    
    static var token: String = ""
    
    let networkManager: HTTPClient
    let tokenLoader: TokenLoader
    
    public init(networkManager: HTTPClient, tokenLoader: TokenLoader) {
        self.networkManager = networkManager
        self.tokenLoader = tokenLoader
    }
    
    
    public func get(from urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) -> URLSessionDataTaskProtocol {
        if AuthHTTPClient.token.isEmpty {
            return tokenLoader.auth() { result in
                switch result {
                case let .success(auth):
                    AuthHTTPClient.token = auth
                    self.get(from: urlRequest, completion: completion)
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } else {
            let singedUrlRequest = AuthHTTPClient.singREquest(urlRequest: urlRequest)
            return networkManager.get(from: singedUrlRequest, completion: completion)
        }
        
        
    }
    
    static func singREquest(urlRequest: URLRequest) -> URLRequest {
        let params = ["apiKey": AuthHTTPClient.token]
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(params["apiKey"]!)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}
