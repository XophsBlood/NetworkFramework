//
//  LoaderTests.swift
//  NetworkModuleTests
//
//  Created by Камиль Бакаев on 29.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
import NetworkModule

class  LoaderTests: XCTestCase {
    
    struct UncorrectStruct: Codable {
        let why: Int
    }
    
    let url = URL(string: "http://mockurl")!
    
    func getNetworkManager(data: Data) -> HTTPClient {
        let session = MockURLSession()
        let networkManager = MockHTTPClient(session: session, data: data)
        memoryLeakTrack(networkManager)
        return networkManager
    }
    
    func test_tokenLoader() {
        
        let token = "05e686311870f2f2c02821e8ac1eec9aa05bcc09"
        let authResult = AuthResult(auth: true, token: token)
        let data = try! JSONEncoder().encode(authResult)
        let networkManager = getNetworkManager(data: data)
        let tokenloader = HTTPTokenLoader(httpCLient: networkManager)
        
        tokenloader.auth() { result in
            switch result {
            case let .success(newToken):
                XCTAssertEqual(newToken, token)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func test_tokenLoader_With_Uncorrect_Struct() {
        
        let authResult = UncorrectStruct(why: 5)
        let data = try! JSONEncoder().encode(authResult)
        let networkManager = getNetworkManager(data: data)
        let tokenloader = HTTPTokenLoader(httpCLient: networkManager)
        
        tokenloader.auth() { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                print("error is ok")
            }
        }
    }
    
    func test_tokenLoader_With_Empty_Token() {
        
        let token = ""
        let authResult = AuthResult(auth: true, token: token)
        let data = try! JSONEncoder().encode(authResult)
        let networkManager = getNetworkManager(data: data)
        let tokenloader = HTTPTokenLoader(httpCLient: networkManager)
        
        tokenloader.auth() { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                print("error is ok")
            }
        }
    }
    
    func test_ImagesLoader() {
        let picture = MyPicture(croppedPictrure: "String", id: "1")
        let imageResult = ImagesResult(hasMore: true, page: 1, pageCount: 2, pictures: [picture] )
        let data = try! JSONEncoder().encode(imageResult)
        let networkManager = getNetworkManager(data: data)
        let imagesLoader = HTTPImagesLoader(httpCLient: networkManager)
        
        imagesLoader.getImages(with: url) { result in
            
            switch result {
            case let .success(images):
                XCTAssertEqual(images.hasMore, imageResult.hasMore)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func test_ImagesLoader_With_Uncorrect_Struct() {
        let token = ""
        let authResult = AuthResult(auth: true, token: token)
        let data = try! JSONEncoder().encode(authResult)
        let networkManager = getNetworkManager(data: data)
        let imagesLoader = HTTPImagesLoader(httpCLient: networkManager)
        
        imagesLoader.getImages(with: url) { result in
            
            switch result {
            case .success(_):
                XCTFail()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func test_ImageDetailsLoader() {
        
        let imageDetailsResult = ImageDetailsResult(author: "Me", camera: "Mine", croppedPicture: "Picture", fullPicture: "full", id: "12")
        let data = try! JSONEncoder().encode(imageDetailsResult)
        let networkManager = getNetworkManager(data: data)
        let imageDetailsLoader = HTTPImageDetailsLoader(httpCLient: networkManager)
        imageDetailsLoader.getImageDetails(with: url) { result in
            switch result {
            case let .success(imageDetails):
                XCTAssertEqual(imageDetailsResult.author, imageDetails.author)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func test_ImageDetailsLoader_With_Uncorrect_Struct() {
        
        let token = ""
        let authResult = AuthResult(auth: true, token: token)
        let data = try! JSONEncoder().encode(authResult)
        let networkManager = getNetworkManager(data: data)
        let imageDetailsLoader = HTTPImageDetailsLoader(httpCLient: networkManager)
        imageDetailsLoader.getImageDetails(with: url) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                print("error is ok")
            }
        }
    }
    
    
}
