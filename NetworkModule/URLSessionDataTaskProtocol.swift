//
//  URLSessionDataTaskProtocol.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation


public protocol URLSessionDataTaskProtocol { func resume() }

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
