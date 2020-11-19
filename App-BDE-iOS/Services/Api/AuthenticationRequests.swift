//
//  AuthenticationRequests.swift
//  FYD
//
//  Created by Maxence Mottard on 30/10/2020.
//  Copyright © 2020 Nicolas Barbosa. All rights reserved.
//

import Foundation
import Combine

final class AuthenticationRequests: Request {
    
    func login(_ body: LoginDTO) -> AnyPublisher<AuthToken, Error> {
        guard let url = URL(string: "https://lyon-ynov-bde-api.herokuapp.com/api/auth") else {
            return AnyPublisher(Empty())
        }
        
        return request(url, httpMethod: .POST, body: body, decodeType: AuthToken.self)
    }
}