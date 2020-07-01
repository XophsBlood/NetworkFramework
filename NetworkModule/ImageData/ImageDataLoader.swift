//
//  ImageDataLoader.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 29.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

protocol ImageDataLoader {
    func getImageData(with url: URL, completion: @escaping (Swift.Result<Data, Error>) -> ())
}
