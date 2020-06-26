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
    
    init(httpClient: HTTPClient) {
        networkManager = httpClient
    }
    
    
    public func get(from urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) -> URLSessionDataTaskProtocol {
        
        let params = ["apiKey": AuthHTTPClient.token]
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(params["apiKey"]!)", forHTTPHeaderField: "Authorization")
        return networkManager.get(from: urlRequest, completion: completion)
    }
}
