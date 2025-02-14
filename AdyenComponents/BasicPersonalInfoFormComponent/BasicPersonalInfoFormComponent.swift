//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen
import Foundation
import UIKit

/// A component that provides a form consisting of first name, last name, phone, and email.
/// :nodoc:
public final class BasicPersonalInfoFormComponent: AbstractPersonalInformationComponent {

    /// Configuration for Basic Personal Information Component
    public typealias Configuration = PersonalInformationConfiguration
    
    /// Initializes the component.
    /// - Parameters:
    ///   - paymentMethod: The payment method.
    ///   - apiContext: The component's API context.
    ///   - configuration: The component's configuration.
    public init(paymentMethod: PaymentMethod,
                apiContext: APIContext,
                configuration: Configuration = .init()) {
        
        super.init(paymentMethod: paymentMethod,
                   apiContext: apiContext,
                   fields: [.firstName, .lastName, .phone, .email],
                   configuration: configuration)
    }

    override public func phoneExtensions() -> [PhoneExtension] {
        let query = PhoneExtensionsQuery(paymentMethod: .generic)
        return PhoneExtensionsRepository.get(with: query)
    }

    override public func submitButtonTitle() -> String {
        localizedString(.confirmPurchase, configuration.localizationParameters)
    }

    override public func createPaymentDetails() throws -> PaymentMethodDetails {
        guard let firstNameItem = firstNameItem,
              let lastNameItem = lastNameItem,
              let emailItem = emailItem,
              let phoneItem = phoneItem else {
                  throw UnknownError(errorDescription: "There seems to be an error in the BasicPersonalInfoFormComponent configuration.")
              }
        return BasicPersonalInfoFormDetails(paymentMethod: paymentMethod,
                                            firstName: firstNameItem.value,
                                            lastName: lastNameItem.value,
                                            emailAddress: emailItem.value,
                                            telephoneNumber: phoneItem.phoneNumber)
    }
}

/// Provides a form for personal information, required for E-context ATM  payments.
public typealias EContextATMComponent = BasicPersonalInfoFormComponent

/// Provides a form for personal information, required for E-context Store payments.
public typealias EContextStoreComponent = BasicPersonalInfoFormComponent

/// Provides a form for personal information, required for E-context Online  payments.
public typealias EContextOnlineComponent = BasicPersonalInfoFormComponent

/// Provides a form for personal information, required for 7eleven  payments.
public typealias SevenElevenComponent = BasicPersonalInfoFormComponent
