//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen
import Foundation

/// Represents any structure/class that can be initialized without any parameters.
/// :nodoc:
public protocol APIContextInitializable {
    /// Initializer that takes an `APIContext`.
    init(apiContext: APIContext)
}

/// Describes the expected interface from any ActionComponent that handles WeChat Pay sdk action.
/// :nodoc:
public protocol AnyWeChatPaySDKActionComponent: ActionComponent, DeviceDependent, APIContextInitializable {

    /// Handles the action.
    ///
    /// - Parameter action: The WeChat Pay action.
    func handle(_ action: WeChatPaySDKAction)

}

/// Loads the concrete WeChatPaySDKActionComponent Class dynamically.
/// :nodoc:
public func loadTheConcreteWeChatPaySDKActionComponentClass() -> AnyWeChatPaySDKActionComponent.Type? {
    ["AdyenWeChatPay.WeChatPaySDKActionComponent",
     "Adyen.WeChatPaySDKActionComponent"].compactMap { NSClassFromString($0) as? AnyWeChatPaySDKActionComponent.Type }.first
}
