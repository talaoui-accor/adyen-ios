//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen
import Foundation
import UIKit

/// A component that provides a form for MB Way payments.
public final class MBWayComponent: AbstractPersonalInformationComponent {
    
    /// Configuration for MB Way Component
    public typealias Configuration = PersonalInformationConfiguration
    
    /// :nodoc:
    private let mbWayPaymentMethod: MBWayPaymentMethod

    /// Initializes the MB Way component.
    /// - Parameters:
    ///   - paymentMethod: The MB Way payment method.
    ///   - apiContext: The component's API context.
    ///   - configuration: The component's configuration.
    public init(paymentMethod: MBWayPaymentMethod,
                apiContext: APIContext,
                configuration: Configuration = .init()) {
        self.mbWayPaymentMethod = paymentMethod
        super.init(paymentMethod: paymentMethod,
                   apiContext: apiContext,
                   fields: [.phone],
                   configuration: configuration)
    }

    override public func submitButtonTitle() -> String {
        localizedString(.continueTo, configuration.localizationParameters, paymentMethod.name)
    }

    override public func phoneExtensions() -> [PhoneExtension] {
        let query = PhoneExtensionsQuery(paymentMethod: PhoneNumberPaymentMethod.mbWay)
        return PhoneExtensionsRepository.get(with: query)
    }

    override public func createPaymentDetails() throws -> PaymentMethodDetails {
        guard let phoneItem = phoneItem else {
            throw UnknownError(errorDescription: "There seems to be an error in the BasicPersonalInfoFormComponent configuration.")
        }
        return MBWayDetails(paymentMethod: paymentMethod,
                            telephoneNumber: phoneItem.phoneNumber)
    }
}
