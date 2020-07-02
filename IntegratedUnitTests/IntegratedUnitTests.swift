//
//  IntegratedUnitTests.swift
//  IntegratedUnitTests
//
//  Created by Камиль Бакаев on 26.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
@testable import CoreLogic

class IntegratedUnitTests: XCTestCase {
    let expectation = XCTestExpectation(description: "Download https://failUrl")

    func test_auth() {
        let myURLSession = URLSession(configuration: .default)
        let httpClient = NetworkManager(session: myURLSession)
        let tokenloader = HTTPTokenLoader(httpCLient: httpClient)
        let auth = AuthHTTPClient(networkManager: httpClient, tokenLoader: tokenloader)

        tokenloader.auth() { result in
            switch result {
            case let .success(token):
                print(AuthHTTPClient.token)
                print(token)
            case let .failure(error):
                print(error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)

        
        
    }
    
    func test_images() {
        let myURLSession = URLSession(configuration: .default)
        let httpClient = NetworkManager(session: myURLSession)
        let tokenloader = HTTPTokenLoader(httpCLient: httpClient)
        let auth = AuthHTTPClient(networkManager: httpClient, tokenLoader: tokenloader)
        let imageLoader = HTTPImagesLoader(httpCLient: auth)
        let myurl = URL(string: "http://195.39.233.28:8035/images")

        imageLoader.getImages(with: myurl!) { result in
            switch result {
            case let .success(images):
                print(images.pictures)
            case let .failure(error):
                print(error)
            }
            self.expectation.fulfill()

        }

        wait(for: [expectation], timeout: 10.0)



    }

    func test_image() {
        let myURLSession = URLSession(configuration: .default)
        let httpClient = NetworkManager(session: myURLSession)
        let tokenloader = HTTPTokenLoader(httpCLient: httpClient)
        let auth = AuthHTTPClient(networkManager: httpClient, tokenLoader: tokenloader)
        let imageDetailsLoader = HTTPImageDetailsLoader(httpCLient: auth)

        let myurl = URL(string: "http://195.39.233.28:8035/images/51fbadf55aa5d2966e98")

        imageDetailsLoader.getImageDetails(with: myurl!) { result in
            switch result {
            case let .success(imageDetails):
                print(imageDetails)
            case let .failure(error):
                print(error)
            }
            self.expectation.fulfill()

        }

        wait(for: [expectation], timeout: 10.0)



    }

}
