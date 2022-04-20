//
// Copyright © 2020 Adyen. All rights reserved.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

@testable import Adyen
@testable import AdyenComponents
import XCTest

class QiwiWalletComponentTests: XCTestCase {
    
    lazy var phoneExtensions = [PhoneExtension(value: "+1", countryCode: "US"), PhoneExtension(value: "+3", countryCode: "UK")]
    lazy var method = QiwiWalletPaymentMethod(type: .qiwiWallet, name: "test_name", phoneExtensions: phoneExtensions)
    let payment = Payment(amount: Amount(value: 2, currencyCode: "EUR"), countryCode: "DE")
    
    func testLocalizationWithCustomTableName() throws {
        let config = QiwiWalletComponent.Configuration(localizationParameters: LocalizationParameters(tableName: "AdyenUIHost", keySeparator: nil))
        let sut = QiwiWalletComponent(paymentMethod: method, apiContext: Dummy.context, configuration: config)
        sut.payment = payment
        
        let expectedSelectableValues = phoneExtensions.map { PhoneExtensionPickerItem(identifier: $0.countryCode, element: $0) }
        XCTAssertEqual(sut.phoneItem?.phonePrefixItem.selectableValues, expectedSelectableValues)
        
        XCTAssertEqual(sut.phoneItem?.title, localizedString(.phoneNumberTitle, sut.configuration.localizationParameters))
        XCTAssertEqual(sut.phoneItem?.placeholder, localizedString(.phoneNumberPlaceholder, sut.configuration.localizationParameters))
        XCTAssertEqual(sut.phoneItem?.validationFailureMessage, localizedString(.phoneNumberInvalid, sut.configuration.localizationParameters))
        XCTAssertEqual(sut.phoneItem?.prefix, "+1")
        XCTAssertEqual(sut.phoneItem?.phonePrefixItem.selectableValues, expectedSelectableValues)
        XCTAssertEqual(sut.phoneItem?.phonePrefixItem.value.identifier, "US")
        
        XCTAssertEqual(sut.button.title, localizedString(.continueTo, sut.configuration.localizationParameters, method.name))
        XCTAssertTrue(sut.button.title!.contains(method.name))
    }
    
    func testLocalizationWithCustomKeySeparator() throws {
        let config = QiwiWalletComponent.Configuration(localizationParameters: LocalizationParameters(tableName: "AdyenUIHostCustomSeparator", keySeparator: "_"))
        let sut = QiwiWalletComponent(paymentMethod: method, apiContext: Dummy.context, configuration: config)
        sut.payment = payment
        
        let expectedSelectableValues = phoneExtensions.map { PhoneExtensionPickerItem(identifier: $0.countryCode, element: $0) }
        XCTAssertEqual(sut.phoneItem?.phonePrefixItem.selectableValues, expectedSelectableValues)
        
        XCTAssertEqual(sut.phoneItem?.title, localizedString(LocalizationKey(key: "adyen_phoneNumber_title"), sut.configuration.localizationParameters))
        XCTAssertEqual(sut.phoneItem?.placeholder, localizedString(LocalizationKey(key: "adyen_phoneNumber_placeholder"), sut.configuration.localizationParameters))
        XCTAssertEqual(sut.phoneItem?.validationFailureMessage, localizedString(LocalizationKey(key: "adyen_phoneNumber_invalid"), sut.configuration.localizationParameters))
        XCTAssertEqual(sut.phoneItem?.prefix, "+1")
        XCTAssertEqual(sut.phoneItem?.phonePrefixItem.selectableValues, expectedSelectableValues)
        XCTAssertEqual(sut.phoneItem?.phonePrefixItem.value.identifier, "US")
        
        XCTAssertEqual(sut.button.title, localizedString(LocalizationKey(key: "adyen_continueTo"), sut.configuration.localizationParameters, method.name))
    }
    
    func testUIConfiguration() {
        var style = FormComponentStyle()
        
        /// Footer
        style.mainButtonItem.button.title.color = .white
        style.mainButtonItem.button.title.backgroundColor = .red
        style.mainButtonItem.button.title.textAlignment = .center
        style.mainButtonItem.button.title.font = .systemFont(ofSize: 22)
        style.mainButtonItem.button.backgroundColor = .red
        style.mainButtonItem.backgroundColor = .brown
        
        /// background color
        style.backgroundColor = .red
        
        /// Text field
        style.textField.text.color = .red
        style.textField.text.font = .systemFont(ofSize: 13)
        style.textField.text.textAlignment = .right
        
        style.textField.title.backgroundColor = .blue
        style.textField.title.color = .yellow
        style.textField.title.font = .systemFont(ofSize: 20)
        style.textField.title.textAlignment = .center
        style.textField.backgroundColor = .red
        
        let config = QiwiWalletComponent.Configuration(style: style)
        let sut = QiwiWalletComponent(paymentMethod: method, apiContext: Dummy.context, configuration: config)

        UIApplication.shared.keyWindow?.rootViewController = sut.viewController
        
        let expectation = XCTestExpectation(description: "Dummy Expectation")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            let phoneNumberView: FormPhoneNumberItemView? = sut.viewController.view.findView(with: "AdyenComponents.QiwiWalletComponent.phoneNumberItem")
            let phoneNumberViewTitleLabel: UILabel? = sut.viewController.view.findView(with: "AdyenComponents.QiwiWalletComponent.phoneNumberItem.titleLabel")
            let phoneNumberViewTextField: UITextField? = sut.viewController.view.findView(with: "AdyenComponents.QiwiWalletComponent.phoneNumberItem.textField")
            
            let phoneExtensionView: FormPhoneExtensionPickerItemView? = sut.viewController.view.findView(with: "Adyen.FormPhoneNumberItem.phoneExtensionPickerItem")
            let phoneExtensionViewLabel: UILabel? = sut.viewController.view.findView(with: "Adyen.FormPhoneNumberItem.phoneExtensionPickerItem.inputControl.label")
            
            let payButtonItemViewButton: UIControl? = sut.viewController.view.findView(with: "AdyenComponents.QiwiWalletComponent.payButtonItem.button")
            let payButtonItemViewButtonTitle: UILabel? = sut.viewController.view.findView(with: "AdyenComponents.QiwiWalletComponent.payButtonItem.button.titleLabel")
            
            /// Test phone number field
            XCTAssertEqual(phoneNumberView?.backgroundColor, .red)
            XCTAssertEqual(phoneNumberViewTitleLabel?.textColor, sut.viewController.view.tintColor)
            XCTAssertEqual(phoneNumberViewTitleLabel?.backgroundColor, .blue)
            XCTAssertEqual(phoneNumberViewTitleLabel?.textAlignment, .center)
            XCTAssertEqual(phoneNumberViewTitleLabel?.font, .systemFont(ofSize: 20))
            XCTAssertEqual(phoneNumberViewTextField?.backgroundColor, .red)
            XCTAssertEqual(phoneNumberViewTextField?.textAlignment, .right)
            XCTAssertEqual(phoneNumberViewTextField?.textColor, .red)
            XCTAssertEqual(phoneNumberViewTextField?.font, .systemFont(ofSize: 13))
            
            /// Test phone extension
            XCTAssertEqual(phoneExtensionView?.backgroundColor, .red)
            XCTAssertEqual(phoneExtensionViewLabel?.textAlignment, .right)
            XCTAssertEqual(phoneExtensionViewLabel?.textColor, .red)
            XCTAssertEqual(phoneExtensionViewLabel?.font, .systemFont(ofSize: 13))
            
            /// Test footer
            XCTAssertEqual(payButtonItemViewButton?.backgroundColor, .red)
            XCTAssertEqual(payButtonItemViewButtonTitle?.backgroundColor, .red)
            XCTAssertEqual(payButtonItemViewButtonTitle?.textAlignment, .center)
            XCTAssertEqual(payButtonItemViewButtonTitle?.textColor, .white)
            XCTAssertEqual(payButtonItemViewButtonTitle?.font, .systemFont(ofSize: 22))
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testBigTitle() {
        let sut = QiwiWalletComponent(paymentMethod: method, apiContext: Dummy.context, configuration: QiwiWalletComponent.Configuration())

        UIApplication.shared.keyWindow?.rootViewController = sut.viewController
        
        let expectation = XCTestExpectation(description: "Dummy Expectation")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            XCTAssertNil(sut.viewController.view.findView(with: "AdyenComponents.CardComponent.Test name"))
            XCTAssertEqual(sut.viewController.title, self.method.name)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRequiresModalPresentation() {
        let qiwiPaymentMethod = QiwiWalletPaymentMethod(type: .qiwiWallet, name: "Test name")
        let sut = QiwiWalletComponent(paymentMethod: qiwiPaymentMethod, apiContext: Dummy.context, configuration: QiwiWalletComponent.Configuration())
        XCTAssertEqual(sut.requiresModalPresentation, true)
    }

    func testSubmit() {
        let phoneExtensions = [PhoneExtension(value: "+3", countryCode: "UK")]
        let method = QiwiWalletPaymentMethod(type: .qiwiWallet, name: "test_name", phoneExtensions: phoneExtensions)
        let sut = QiwiWalletComponent(paymentMethod: method, apiContext: Dummy.context, configuration: QiwiWalletComponent.Configuration())
        let delegate = PaymentComponentDelegateMock()
        sut.delegate = delegate

        let delegateExpectation = expectation(description: "PaymentComponentDelegate must be called when submit button is clicked.")
        delegate.onDidSubmit = { data, component in
            XCTAssertTrue(component === sut)
            XCTAssertTrue(data.paymentMethod is QiwiWalletDetails)
            let data = data.paymentMethod as! QiwiWalletDetails
            XCTAssertEqual(data.phonePrefix, "+3")
            XCTAssertEqual(data.phoneNumber, "7455573152")

            sut.stopLoadingIfNeeded()
            delegateExpectation.fulfill()
            XCTAssertEqual(sut.viewController.view.isUserInteractionEnabled, true)
            XCTAssertEqual(sut.button.showsActivityIndicator, false)
        }

        UIApplication.shared.keyWindow?.rootViewController = sut.viewController

        let expectation = XCTestExpectation(description: "Dummy Expectation")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            let phoneNumberView: FormPhoneNumberItemView? = sut.viewController.view.findView(with: "AdyenComponents.QiwiWalletComponent.phoneNumberItem")

            let payButtonItemViewButton: UIControl? = sut.viewController.view.findView(with: "AdyenComponents.QiwiWalletComponent.payButtonItem.button")

            self.populate(textItemView: phoneNumberView!, with: "7455573152")

            payButtonItemViewButton?.sendActions(for: .touchUpInside)

            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
