//
//  LocalImageDataLoader.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class LocalImageDataLoader {
    public let store: Cachable
    
    public init(store: Cachable) {
        self.store = store
    }
    
    func getImageData(with url: URL) -> Data? {
        return store.getData(with: url)
    }
    
    func cache(with url: URL, and data: Data) {
        store.save(data: data, url: url)
    }
}
