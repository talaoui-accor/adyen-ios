//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import AdyenNetworking
import Foundation

/// :nodoc:
/// An object that needs an API context to retrieve internal resources
public protocol APIContextAware: AnyObject {
    
    /// :nodoc:
    /// The API context
    var apiContext: APIContext { get }
    
}

/// Struct that defines API context for retrieving internal resources.
public struct APIContext: AnyAPIContext {
    
    /// The query parameters.
    public var queryParameters: [URLQueryItem] {
        [URLQueryItem(name: "clientKey", value: clientKey)]
    }
    
    /// The HTTP headers.
    public let headers: [String: String] = ["Content-Type": "application/json"]

    /// Environment to retrieve internal resources from.
    public let environment: AnyAPIEnvironment
    
    /// The client key that corresponds to the web service user you will use for initiating the payment.
    /// See https://docs.adyen.com/user-management/client-side-authentication for more information.
    public let clientKey: String
    
    /// Initializes the APIContext
    /// - Parameters:
    ///   - environment: The environment to retrieve internal resources from.
    ///   - clientKey: The client key that corresponds to the web service user you will use for initiating the payment.
    /// - Throws: `ClientKeyError.invalidClientKey` if the client key is invalid.
    public init(environment: AnyAPIEnvironment, clientKey: String) throws {
        guard ClientKeyValidator().isValid(clientKey) else {
            throw ClientKeyError.invalidClientKey
        }

        self.environment = environment
        self.clientKey = clientKey
    }
            
}
