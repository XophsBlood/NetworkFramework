//
//  HTTPClientProtocol.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

protocol HTTPClient {
    
    func get(from url: URL, completion: @escaping (Swift.Result<(Data,HTTPURLResponse), Error>) -> ())
    
}
