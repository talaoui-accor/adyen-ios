//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

/// Atome payment method.
public struct AtomePaymentMethod: PaymentMethod {
    
    public let type: PaymentMethodType
    
    public let name: String
    
    public var merchantProvidedDisplayInformation: MerchantCustomDisplayInformation?
    
    /// :nodoc:
    public func buildComponent(using builder: PaymentComponentBuilder) -> PaymentComponent? {
        builder.build(paymentMethod: self)
    }
    
    // MARK: - Private
    
    private enum CodingKeys: String, CodingKey {
        case type
        case name
    }
}
