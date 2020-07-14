//
//  LocalImageDataLoader.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class LocalImageDataLoader: ImagesLoader, ImageDataLoader {
    
    public let store: ImageStore
    
    public init(store: ImageStore) {
        self.store = store
    }
    
    func getImageData(with url: URL) -> Data? {
        return store.getData(with: url)
    }
    
    func cache(with url: URL, and data: Data) {
        if let pageNumber = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value,
            let mainCacheData = store.getMainCacheData(page: pageNumber),
            let tempImagesDataEntity = try? JSONDecoder().decode(TempImagesDataEntity.self, from: mainCacheData) {
            let temp = tempImagesDataEntity
            temp.imagesData.append(url)
            if let newData = try? JSONEncoder().encode(temp) {
                store.saveMain(data: newData, page: pageNumber)
            }
        }
        store.save(data: data, url: url)
    }
    
    func saveMain(imagesResult: ImagesResult) {
        let imagesCacheEntity = TempImagesDataEntity(cacheTime: Date().timeIntervalSinceReferenceDate, imagesResult: imagesResult)
        let data = try! JSONEncoder().encode(imagesCacheEntity)
        store.clearCache(page: String(imagesResult.page))
        store.saveMain(data: data, page: String(imagesResult.page))
    }
    
    public func getImages(with url: URL, completion: @escaping (Result<ImagesResult, Error>) -> ()) {
        let pageNumber = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value ?? "1"
        
        if let entity = getTempEntity(for: pageNumber) {
            completion(.success(entity.imagesResult))
        } else {
            completion(.failure(NSError()))
        }
        
    }
    
    public func getImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) -> URLSessionDataTaskProtocol? {
        if let entity = getImageData(with: url) {
            completion(.success(entity))
        } else {
            completion(.failure(NSError()))
        }
        
        return nil
    }
    
    private func getTempEntity(for page: String) -> TempImagesDataEntity? {
        if store.chechExpirationDate(page: page), let mainCacheData = store.getMainCacheData(page: page), let tempEntity = try? JSONDecoder().decode(TempImagesDataEntity.self, from: mainCacheData) {
                        
            return tempEntity
        
        } else {
            return nil
        }
    }
    
    
}
