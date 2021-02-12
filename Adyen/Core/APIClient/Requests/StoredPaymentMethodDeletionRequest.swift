//
//  StoredPaymentMethodDeletionRequest.swift
//  Adyen
//
//  Created by Vladimir Abramichev on 12/02/2021.
//  Copyright © 2021 Adyen. All rights reserved.
//

import Foundation

internal struct StoredPaymentMethodDeletionRequest: Request {
    /// The type of response expected from the request.
    typealias ResponseType = StoredPaymentMethodDeletionResponse

    /// The payment session.
    internal var paymentSession: PaymentSession

    /// The payment method to delete.
    internal var paymentMethod: PaymentMethod

    /// The URL to which the request should be made.
    internal var url: URL {
        return paymentSession.deleteStoredPaymentMethodURL
    }

    // MARK: - Encoding

    internal func encode(to encoder: Encoder) throws {
        try encodePaymentData(to: encoder)
    }

}

/// The response to a stored payment method deletion request.
internal struct StoredPaymentMethodDeletionResponse: Response {}
