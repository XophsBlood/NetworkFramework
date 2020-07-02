//
//  LoaderTests.swift
//  NetworkModuleTests
//
//  Created by Камиль Бакаев on 29.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
import CoreLogic

class  LoaderTests: XCTestCase {
    
    struct UncorrectStruct: Codable {
        let why: Int
    }
    
    let url = URL(string: "http://mockurl")!
    
    func getNetworkManager<T: Encodable>(structure: T) -> HTTPClient {
        let session = MockURLSession()
        let data = try! JSONEncoder().encode(structure)
        let networkManager = MockHTTPClient(session: session, data: data)
        memoryLeakTrack(networkManager)
        return networkManager
    }
    
    func test_tokenLoader() {
        
        let token = "05e686311870f2f2c02821e8ac1eec9aa05bcc09"
        let authResult = AuthResult(auth: true, token: token)

        let networkManager = getNetworkManager(structure: authResult)
        let tokenloader = HTTPTokenLoader(httpCLient: networkManager)
        
        expect(url: url, tokenloader, expectedResult: token)
    }
    
    func test_tokenLoader_With_Uncorrect_Struct() {
        let authResult = UncorrectStruct(why: 5)

        let networkManager = getNetworkManager(structure: authResult)
        let tokenloader = HTTPTokenLoader(httpCLient: networkManager)
        
        expectFail(url: URL(string: "URL")!, tokenloader)
        
    }
    
    func test_tokenLoader_With_Empty_Token() {
        let token = ""
        let authResult = AuthResult(auth: true, token: token)
       
        let networkManager = getNetworkManager(structure: authResult)
        let tokenloader = HTTPTokenLoader(httpCLient: networkManager)
        
        expectFail(url: url, tokenloader)
    }
    
    func test_ImagesLoader() {
        let picture = MyPicture(croppedPictrure: "String", id: "1")
        let imageResult = ImagesResult(hasMore: true, page: 1, pageCount: 2, pictures: [picture] )
        
        let networkManager = getNetworkManager(structure: imageResult)
        let imagesLoader = HTTPImagesLoader(httpCLient: networkManager)
        
        expect(url: url, imagesLoader, expectedResult: imageResult)
    }
    
    func test_ImagesLoader_With_Uncorrect_Struct() {
        let token = ""
        let authResult = AuthResult(auth: true, token: token)
        
        let networkManager = getNetworkManager(structure: authResult)
        let imagesLoader = HTTPImagesLoader(httpCLient: networkManager)
        
        expectFail(url: url, imagesLoader)
    }
    
    func test_ImageDetailsLoader() {
        
        let imageDetailsResult = ImageDetailsResult(author: "Me", camera: "Mine", croppedPicture: "Picture", fullPicture: "full", id: "12")
        
        let networkManager = getNetworkManager(structure: imageDetailsResult)
        let imageDetailsLoader = HTTPImageDetailsLoader(httpCLient: networkManager)
        
        expect(url: url, imageDetailsLoader, expectedResult: imageDetailsResult)
    }
    
    func test_ImageDetailsLoader_With_Uncorrect_Struct() {
        
        let token = ""
        let authResult = AuthResult(auth: true, token: token)
        
        let networkManager = getNetworkManager(structure: authResult)
        let imageDetailsLoader = HTTPImageDetailsLoader(httpCLient: networkManager)
        
        expectFail(url: url, imageDetailsLoader)
    }
    
    private func expectFail<T: Loader>(url: URL, _ sut: T) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load(url: url) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                print("error is ok")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect<T: Loader, R: Equatable>(url: URL, _ sut: T, expectedResult: R) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load(url: url) { result in
            switch result {
            case let .success(structure):
                XCTAssertEqual(structure as! R, expectedResult)
            case .failure(_):
                XCTFail()
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

protocol Loader {
    associatedtype T
    func load(url: URL, completion: @escaping (Result<T, Error>) -> ())
}

extension HTTPTokenLoader: Loader {
    typealias T = String
    func load(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
        auth(completion: completion)
    }
}

extension HTTPImagesLoader: Loader {
    typealias T = ImagesResult
    func load(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
        getImages(with: url, completion: completion)
    }
}

extension HTTPImageDetailsLoader: Loader {
    typealias T = ImageDetailsResult
    func load(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
        getImageDetails(with: url, completion: completion)
    }
}

extension ImagesResult: Equatable {
    public static func == (lhs: ImagesResult, rhs: ImagesResult) -> Bool {
        return lhs.hasMore == rhs.hasMore && lhs.page == rhs.page && lhs.pageCount == rhs.pageCount
    }
}

extension ImageDetailsResult: Equatable {
    public static func == (lhs: ImageDetailsResult, rhs: ImageDetailsResult) -> Bool {
        return lhs.author == rhs.author && lhs.camera == rhs.camera && lhs.croppedPicture == rhs.croppedPicture && lhs.fullPicture == rhs.fullPicture
    }
}
