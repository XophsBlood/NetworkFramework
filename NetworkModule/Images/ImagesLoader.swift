//
//  ImagesLoader.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 24.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

protocol ImagesLoader {
    func getImages(with url: URL, completion: @escaping (Swift.Result<ImagesResult, Error>) -> ())
}
