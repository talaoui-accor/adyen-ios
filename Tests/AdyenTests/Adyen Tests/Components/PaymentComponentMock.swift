//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen

class PaymentComponentMock: PaymentComponent {
    
    let apiContext = Dummy.context
    
    var paymentMethod: PaymentMethod
    
    var delegate: PaymentComponentDelegate?
    
    init(paymentMethod: PaymentMethod) {
        self.paymentMethod = paymentMethod
    }
    
}
