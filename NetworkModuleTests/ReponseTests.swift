//
//  ReponseTests.swift
//  NetworkModuleTests
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
import NetworkModule

enum SomeError: Error {
    case unexpected
}

class HttpClientTests: XCTestCase {
    let url = URL(string: "http://mockurl")!
    
    func getNetworkManager() -> (HTTPClient, MockURLSession) {
        let session = MockURLSession()
        let networkManager = NetworkManager(session: session)
        memoryLeakTrack(networkManager)
        return (networkManager, session)
    }
    
    // Data:Value Response:Value Error:nil
    func test_get_should_return_Data_and_Reponse() {
        let myExpectation = expectation(description: "")
        let (networkManager, session) = getNetworkManager()
        let urlRequest = URLRequest(url: url)
        
        let expectedData = "{}".data(using: .utf8)
        

        session.nextData = expectedData
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        
        var actualData: Data?
        var actualResponse: HTTPURLResponse?
        let datatask = networkManager.get(from: urlRequest) { (result) in
            switch result {
            case let .success((data, response)):
                actualData = data
                actualResponse = response
            default:
                XCTFail()
            }
            myExpectation.fulfill()
        }
        
        wait(for: [myExpectation], timeout: 10.0)
        XCTAssertEqual((datatask as? MockURLSessionDataTask)?.counter, 1)
        XCTAssertNotNil(actualData)
        XCTAssertNotNil(actualResponse)
    }
    
    // Data:nil Response:nil Error:nil
    func test_get_should_not_return_Error() {
        let (networkManager, session) = getNetworkManager()
        
        resultForError(data: nil, reponse: nil, error: nil, session: session, networkManager: networkManager)
    }
    
    // Data:nil Response:nil Error:Value
    func test_get_should_return_Error() {
        let urlRequest = URLRequest(url: url)
        let myExpectation = expectation(description: "")
        let (networkManager, session) = getNetworkManager()
        
        let sendError = NSError(domain: "error", code: 5, userInfo: nil)
        session.nextError = sendError
        var actualError: Error?
        
        let datatask = networkManager.get(from: urlRequest) { (result) in
            switch result {
            case let .failure(error):
                actualError = error
            default:
                XCTFail()
            }
            myExpectation.fulfill()
        }
        wait(for: [myExpectation], timeout: 10.0)
        XCTAssertEqual((datatask as? MockURLSessionDataTask)?.counter, 1)
        XCTAssertEqual(actualError as NSError?, sendError)
    
    }
    
    // Data:nil Response:Value Error:Value
    func test_get_should_return_only_Reponse() {
        let (networkManager, session) = getNetworkManager()
        
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let error = SomeError.unexpected
        
        resultForError(data: nil, reponse: response, error: error, session: session, networkManager: networkManager)
    }
    
    // Data:Value Response:nil Error:nil
    func test_get_should_return_only_Data() {
        let (networkManager, session) = getNetworkManager()
        let expectedData = "{}".data(using: .utf8)
        
        
        let data = expectedData
        
        resultForError(data: data, reponse: nil, error: nil, session: session, networkManager: networkManager)
    }
    
    // Data:Value Response:nil Error:Value
    func test_get_should_return_Data_and_Error() {
        let (networkManager, session) = getNetworkManager()
        let expectedData = "{}".data(using: .utf8)
        
        
        let data = expectedData
        let error = SomeError.unexpected
        
        resultForError(data: data, reponse: nil, error: error, session: session, networkManager: networkManager)
    }
    
    // Data:Value Response:Value Error:Value
    func test_get_should_return_Data_Response_And_Error() {
        let (networkManager, session) = getNetworkManager()
        let expectedData = "{}".data(using: .utf8)
        
        
        let data = expectedData
        let error = SomeError.unexpected
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        
        resultForError(data: data, reponse: response, error: error, session: session, networkManager: networkManager)
    }
    
    // Data:nil Response:Value Error:Value
    func test_get_should_return_Response_and_Error() {
        let (networkManager, session) = getNetworkManager()
        
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let error = SomeError.unexpected
        
        resultForError(data: nil, reponse: response, error: error, session: session, networkManager: networkManager)
    }
    
    func resultForError(data: Data?, reponse: HTTPURLResponse?, error: Error?, session: MockURLSession, networkManager: HTTPClient) {
        let urlRequest = URLRequest(url: url)
        session.nextResponse = reponse
        session.nextError = error
        session.nextData = data
        let myExpectation = expectation(description: "")
        
        let datatask = networkManager.get(from: urlRequest) { (result) in
            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
            default:
                XCTFail()
            }
            myExpectation.fulfill()
        }
        wait(for: [myExpectation], timeout: 10.0)
        XCTAssertEqual((datatask as? MockURLSessionDataTask)?.counter, 1)
    
        
    }
    
}


extension XCTestCase {
    func memoryLeakTrack(_ instance: AnyObject, file: StaticString = #file, line:UInt = #line) {addTeardownBlock { [weak instance] in
        XCTAssertNil(instance, "Potential leak.", file: file, line: line)}}
}
