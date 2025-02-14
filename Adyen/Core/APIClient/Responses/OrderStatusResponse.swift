//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import AdyenNetworking
import Foundation

/// :nodoc:
public struct OrderStatusResponse: Response {

    /// The remaining amount to be paid.
    /// :nodoc:
    public let remainingAmount: Amount

    /// The payment methods already used to partially pay.
    /// :nodoc:
    public let paymentMethods: [OrderPaymentMethod]?

    /// :nodoc:
    public init(remainingAmount: Amount,
                paymentMethods: [OrderPaymentMethod]?) {
        self.remainingAmount = remainingAmount
        self.paymentMethods = paymentMethods
    }

    /// :nodoc:
    internal enum CodingKeys: String, CodingKey {
        case remainingAmount
        case paymentMethods
    }
}

/// :nodoc:
public struct OrderPaymentMethod: PaymentMethod {

    /// :nodoc:
    public var name: String {
        String.Adyen.securedString + lastFour
    }
    
    public var merchantProvidedDisplayInformation: MerchantCustomDisplayInformation?

    /// :nodoc:
    public let lastFour: String

    /// :nodoc:
    public let type: PaymentMethodType

    /// :nodoc:
    public let transactionLimit: Amount?

    /// :nodoc:
    public let amount: Amount

    /// :nodoc:
    public init(lastFour: String,
                type: PaymentMethodType,
                transactionLimit: Amount?,
                amount: Amount) {
        self.lastFour = lastFour
        self.type = type
        self.transactionLimit = transactionLimit
        self.amount = amount
    }

    /// :nodoc:
    public func defaultDisplayInformation(using parameters: LocalizationParameters?) -> DisplayInformation {
        let disclosureText = AmountFormatter.formatted(amount: -amount.value,
                                                       currencyCode: amount.currencyCode,
                                                       localeIdentifier: parameters?.locale)
        return DisplayInformation(title: name,
                                  subtitle: nil,
                                  logoName: type.rawValue,
                                  disclosureText: disclosureText)
    }

    public func buildComponent(using builder: PaymentComponentBuilder) -> PaymentComponent? {
        AlreadyPaidPaymentComponent(paymentMethod: self, apiContext: builder.apiContext)
    }

    private enum CodingKeys: String, CodingKey {
        case lastFour
        case amount
        case transactionLimit
        case type
    }
}
