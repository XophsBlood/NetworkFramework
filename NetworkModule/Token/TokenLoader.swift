//
//  TokenLoader.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 24.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public protocol TokenLoader {
    @discardableResult
    func auth(completion: @escaping (Swift.Result<String, Error>) -> ()) -> URLSessionDataTaskProtocol
}
