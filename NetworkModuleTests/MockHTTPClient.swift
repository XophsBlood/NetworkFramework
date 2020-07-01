//
//  MockAuthHTTPClient.swift
//  NetworkModuleTests
//
//  Created by Камиль Бакаев on 01.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import NetworkModule

class MockHTTPClient: HTTPClient {
    
    let data: Data
    let session: URLSessionProtocol
    
    
    public init(session: URLSessionProtocol, data: Data) {
        self.session = session
        self.data = data
    }
    
    func get(from urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) -> URLSessionDataTaskProtocol {
        let responseOne: HTTPURLResponse = HTTPURLResponse(url: URL(string: "url")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        
        let task = session.dataTask(request: urlRequest, completionHandler: { (data, response, error) -> Void in
            completion(.success((self.data, responseOne)))
        })
        
        return task
        
    }
    
}
