//
//  MockTokenLoader.swift
//  CoreLogicTests
//
//  Created by Камиль Бакаев on 02.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic

class MockTokenLoader: TokenLoader {
    var called = false
    func auth(completion: @escaping (Result<String, Error>) -> ()) -> URLSessionDataTaskProtocol {
        called = true
        completion(.success("token"))
        return MockURLSessionDataTask()
    }
    
    
}
