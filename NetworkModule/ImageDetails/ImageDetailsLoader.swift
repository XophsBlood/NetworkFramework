//
//  ImageDetailsLoader.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 26.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

protocol ImageDetailsLoader {
    func getImageDetails(with url: URL, completion: @escaping (Swift.Result<ImageDetailsResult, Error>) -> ())
}
