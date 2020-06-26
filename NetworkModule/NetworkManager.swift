//
//  NetworkManager.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public enum UnexpectedError: Error {
    case unexpected
}



public class NetworkManager: HTTPClient {
    
    private let session: URLSessionProtocol
    
    public init(session: URLSessionProtocol) {
        self.session = session
    }
    
    public func get(from urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) -> URLSessionDataTaskProtocol {
        
        let task = session.dataTask(request: urlRequest, completionHandler: { (data, response, error) -> Void in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                }
                throw UnexpectedError.unexpected
            })
            
        })
        
        task.resume()
        
        return task
    }
    
    
}



