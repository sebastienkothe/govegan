//
//  Service.swift
//  govegan
//
//  Created by Mosma on 03/06/2021.
//

import AuthenticationServices

enum AuthState {
    case signedIn
    case signedOut
}

struct Service {
    static var authState: AuthState = .signedOut
}
