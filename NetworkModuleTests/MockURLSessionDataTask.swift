//
//  MockURLSessionDataTask.swift
//  NetworkModuleTests
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
@testable import CoreLogic

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func cancel() {
        cancel()
    }
    
    private (set) var counter = 0
    func resume() {
        counter += 1
    }
}
