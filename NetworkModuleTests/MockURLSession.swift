//
//  MockURLSession.swift
//  NetworkModuleTests
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
@testable import NetworkModule

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    var nextResponse: HTTPURLResponse?
    
    
//    func successHttpURLResponse(request: URLRequest) {
//        
//        nextResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
//    }
    
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        if let url = request.url {
            let request = URLRequest(url: url)
//            successHttpURLResponse(request: request)
            completionHandler(nextData, nextResponse, nextError)
        }
        return nextDataTask
    }

}
