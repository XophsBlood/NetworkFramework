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
    
    let params = ["apiKey": "23567b218376f79d9415"]
    let url = URL(string: "http://195.39.233.28:8035/auth")
    
    public init(httpCLient: HTTPClient) {
        self.httpClient = httpCLient
    }
    
    
    
    public func auth(completion: @escaping (Swift.Result<String, Error>) -> ()) -> URLSessionDataTaskProtocol {
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpBody = try! JSONEncoder().encode(params)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return httpClient.get(from: urlRequest) { result in
            switch result {
            case let .success(data, _):
                if let authResult: AuthResult = try? JSONDecoder().decode(AuthResult.self, from: data) {
                    if let token = authResult.token, !token.isEmpty {
                        completion(.success(authResult.token!))
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
