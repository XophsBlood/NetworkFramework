//
//  AuthHTTPClientTests.swift
//  CoreLogicTests
//
//  Created by Камиль Бакаев on 02.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
import CoreLogic

class AuthHTTPClientTests: XCTestCase {
    let url = URL(string: "http://mockurl")!
    
    func getNetworkManager() -> (MockHTTPClient, AuthHTTPClient, MockTokenLoader) {
        let session = MockURLSession()
        let data = "{}".data(using: .utf8)!
        let networkManager = MockHTTPClient(session: session, data: data)
        let tokenLoader = MockTokenLoader()
        let authClient = AuthHTTPClient(networkManager: networkManager, tokenLoader: tokenLoader)
        memoryLeakTrack(networkManager)
        return (networkManager, authClient, tokenLoader)
    }

    func test_authClient_with_token() {
        AuthHTTPClient.token = "token"
        let (networkManager, authClient, tokenLoader) = getNetworkManager()
        
        authClient.get(from: URLRequest(url: url)) { _ in
            self.assertParams(firstCall: networkManager.called, secondCall: !tokenLoader.called, auth: networkManager.expectedURLRequest?.allHTTPHeaderFields?.first?.key, token: networkManager.expectedURLRequest?.allHTTPHeaderFields?.first?.value)
        }
    }
    
    func test_authClient_without_token() {
        AuthHTTPClient.token = ""
        let (networkManager, authClient, tokenLoader) = getNetworkManager()
        
        authClient.get(from: URLRequest(url: url)) { _ in
            self.assertParams(firstCall: networkManager.called, secondCall: tokenLoader.called, auth: networkManager.expectedURLRequest?.allHTTPHeaderFields?.first?.key, token: networkManager.expectedURLRequest?.allHTTPHeaderFields?.first?.value)
        }
    }
    
    func assertParams(firstCall: Bool, secondCall: Bool, auth: String?, token: String?) {
        XCTAssertTrue(firstCall)
        XCTAssertTrue(secondCall)
        XCTAssertEqual("Authorization", auth)
        XCTAssertEqual("Bearer token", token)
    }
}
