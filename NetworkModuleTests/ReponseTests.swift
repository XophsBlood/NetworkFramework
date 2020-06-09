//
//  ReponseTests.swift
//  NetworkModuleTests
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
@testable import NetworkModule

enum SomeError: Error {
    case unexpected
}

class HttpClientTests: XCTestCase {
    var networkManager: NetworkManager!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        networkManager = nil
    }
    
    // Data:Value Response:Value Error:nil
    func test_get_should_return_Data_and_Reponse() {
        let expectedData = "{}".data(using: .utf8)
        let url = URL(string: "http://mockurl")!
        
        session.nextData = expectedData
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        
        var actualData: Data?
        var actualResponse: HTTPURLResponse?
        var actualError: Error?
        networkManager.get(from: url) { (result) in
            switch result {
            case let .success((data, response)):
                actualData = data
                actualResponse = response
            default:
                XCTFail()
            }
        }
        XCTAssertNotNil(actualData)
        XCTAssertNotNil(actualResponse)
        XCTAssertNil(actualError)
    }
    
    // Data:nil Response:nil Error:nil
    func test_get_should_not_return_Error() {
        let url = URL(string: "http://mockurl")!
        
        session.nextError = nil
        
        var actualData: Data?
        var actualResponse: HTTPURLResponse?
        var actualError: Error?
        networkManager.get(from: url) { (result) in
            switch result {
            case let .failure(error):
                
                actualError = error
            default:
                XCTFail()
            }
        }
        
        guard let error = actualError as? NetworkModule.UnexpectedError else {
            XCTFail()
            return
        }
        
        XCTAssertNil(actualData)
        XCTAssertNil(actualResponse)
        XCTAssertNotNil(actualError)
    }
    
    // Data:nil Response:nil Error:Value
    func test_get_should_return_Error() {
        let url = URL(string: "http://mockurl")!
        
        session.nextError = SomeError.unexpected
        
        var actualData: Data?
        var actualResponse: HTTPURLResponse?
        var actualError: Error?
        networkManager.get(from: url) { (result) in
            switch result {
            case let .failure(error):
                
                actualError = error
            default:
                XCTFail()
            }
        }
        
        if let error = actualError as? NetworkModule.UnexpectedError {
            XCTFail()
            return
        } else {
            XCTAssertNil(actualData)
            XCTAssertNil(actualResponse)
            XCTAssertNotNil(actualError)
        }
    
    }
    
    // Data:nil Response:Value Error:Value
    func test_get_should_return_only_Reponse() {
        let url = URL(string: "http://mockurl")!
        
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        
        var actualData: Data?
        var actualResponse: HTTPURLResponse?
        var actualError: Error?
        networkManager.get(from: url) { (result) in
            switch result {
            case let .failure(error):
                
                actualError = error
            default:
                XCTFail()
            }
        }
        XCTAssertNil(actualData)
        XCTAssertNil(actualResponse)
        XCTAssertNotNil(actualError)
    }
    
    // Data:Value Response:nil Error:nil
    func test_get_should_return_only_Data() {
        let expectedData = "{}".data(using: .utf8)
        let url = URL(string: "http://mockurl")!
        
        session.nextData = expectedData
        
        var actualData: Data?
        var actualResponse: HTTPURLResponse?
        var actualError: Error?
        networkManager.get(from: url) { (result) in
            switch result {
            case let .failure(error):
                
                actualError = error
            default:
                XCTFail()
            }
        }
        XCTAssertNil(actualData)
        XCTAssertNil(actualResponse)
        XCTAssertNotNil(actualError)
    }
    
    // Data:Value Response:nil Error:Value
    func test_get_should_return_Data_and_Error() {
        let expectedData = "{}".data(using: .utf8)
        let url = URL(string: "http://mockurl")!
        
        session.nextData = expectedData
        session.nextError = SomeError.unexpected
        
        var actualData: Data?
        var actualResponse: HTTPURLResponse?
        var actualError: Error?
        networkManager.get(from: url) { (result) in
            switch result {
            case let .failure(error):
                
                actualError = error
            default:
                XCTFail()
            }
        }
        XCTAssertNil(actualData)
        XCTAssertNil(actualResponse)
        XCTAssertNotNil(actualError)
    }
    
    // Data:Value Response:Value Error:Value
    func test_get_should_return_Data_Response_And_Error() {
        let expectedData = "{}".data(using: .utf8)
        let url = URL(string: "http://mockurl")!
        
        session.nextData = expectedData
        session.nextError = SomeError.unexpected
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        
        var actualData: Data?
        var actualResponse: HTTPURLResponse?
        var actualError: Error?
        networkManager.get(from: url) { (result) in
            switch result {
            case let .failure(error):
                
                actualError = error
            default:
                XCTFail()
            }
        }
        XCTAssertNil(actualData)
        XCTAssertNil(actualResponse)
        XCTAssertNotNil(actualError)
    }
    
    // Data:nil Response:Value Error:Value
    func test_get_should_return_Response_and_Error() {
        let url = URL(string: "http://mockurl")!
        
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        session.nextError = SomeError.unexpected
        
        var actualData: Data?
        var actualResponse: HTTPURLResponse?
        var actualError: Error?
        networkManager.get(from: url) { (result) in
            switch result {
            case let .failure(error):
                
                actualError = error
            default:
                XCTFail()
            }
        }
        XCTAssertNil(actualData)
        XCTAssertNil(actualResponse)
        XCTAssertNotNil(actualError)
    }
    
}
