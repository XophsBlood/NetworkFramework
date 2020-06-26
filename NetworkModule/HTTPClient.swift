//
//  HTTPClientProtocol.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    
    @discardableResult
    func get(from urlRequest: URLRequest, completion: @escaping (Swift.Result<(Data,HTTPURLResponse), Error>) -> ()) -> URLSessionDataTaskProtocol
    
}
