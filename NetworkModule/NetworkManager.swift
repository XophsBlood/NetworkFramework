//
//  NetworkManager.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

enum UnexpectedError: Error {
    case unexpected
}

class NetworkManager: HTTPClient {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) {
        let task = session.dataTask(with: NSURLRequest(url: url), completionHandler: { [weak self] (data, response, error) -> Void in
            
            let result = (data, response, error)
            
            switch result {
            case let (nil, nil, error):
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(UnexpectedError.unexpected))
                }
            case let (data, response, nil):
                if let data = data, let response = response as? HTTPURLResponse {
                    completion(.success((data, response)))
                } else {
                    completion(.failure(UnexpectedError.unexpected))
                }
            default:
                print("lol")
                completion(.failure(UnexpectedError.unexpected))
            }
        })
        task.resume()
    }
    
}
