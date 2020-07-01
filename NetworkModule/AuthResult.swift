//
//  AuthResult.swift
//  NetworkModule
//
//  Created by Камиль Бакаев on 26.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public struct AuthResult: Codable {
    
    let auth: Bool
    let token: String?
    
    public init(auth: Bool, token: String?) {
        self.auth = auth
        self.token = token
    }
}
