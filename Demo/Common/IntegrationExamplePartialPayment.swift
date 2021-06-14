//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen
#if canImport(AdyenCard)
    import AdyenCard
#endif
#if canImport(AdyenComponents)
    import AdyenComponents
#endif
#if canImport(AdyenActions)
    import AdyenActions
#endif
#if canImport(AdyenDropIn)
    import AdyenDropIn
#endif
#if canImport(AdyenNetworking)
    import AdyenNetworking
#endif
import UIKit

extension IntegrationExample: PartialPaymentDelegate {

    internal enum GiftCardError: Error, LocalizedError {
        case noBalance

        internal var errorDescription: String? {
            switch self {
            case .noBalance:
                return "No Balance"
            }
        }
    }

    internal func checkBalance(with data: PaymentComponentData,
                               completion: @escaping (Result<Balance, Error>) -> Void) {
        let request = BalanceCheckRequest(data: data)
        apiClient.perform(request) { [weak self] result in
            self?.handle(result: result, completion: completion)
        }
    }

    private func handle(result: Result<BalanceCheckResponse, Error>,
                        completion: @escaping (Result<Balance, Error>) -> Void) {
        switch result {
        case let .success(response):
            handle(response: response, completion: completion)
        case let .failure(error):
            handle(error: error, completion: completion)
        }
    }

    private func handle(response: BalanceCheckResponse, completion: @escaping (Result<Balance, Error>) -> Void) {
        guard let availableAmount = response.balance else {
            finish(with: GiftCardError.noBalance)
            completion(.failure(GiftCardError.noBalance))
            return
        }
        let balance = Balance(availableAmount: availableAmount, transactionLimit: response.transactionLimit)
        completion(.success(balance))
    }

    private func handle(error: Error, completion: @escaping (Result<Balance, Error>) -> Void) {
        finish(with: error)
        completion(.failure(error))
    }

    internal func requestOrder(_ completion: @escaping (Result<PartialPaymentOrder, Error>) -> Void) {
        let request = CreateOrderRequest(amount: payment.amount, reference: UUID().uuidString)
        apiClient.perform(request) { [weak self] result in
            self?.handle(result: result, completion: completion)
        }
    }

    private func handle(result: Result<CreateOrderResponse, Error>,
                        completion: @escaping (Result<PartialPaymentOrder, Error>) -> Void) {
        switch result {
        case let .success(response):
            completion(.success(response.order))
        case let .failure(error):
            finish(with: error)
            completion(.failure(error))
        }
    }

    internal func cancelOrder(_ order: PartialPaymentOrder) {
        let request = CancelOrderRequest(order: order)
        apiClient.perform(request) { [weak self] result in
            self?.handle(result: result)
        }
    }

    private func handle(result: Result<CancelOrderResponse, Error>) {
        switch result {
        case let .success(response):
            if response.resultCode == .received {
                presentAlert(withTitle: "Order Cancelled")
            } else {
                presentAlert(withTitle: "Something went wrong, order is not canceled but will expire.")
            }
        case let .failure(error):
            finish(with: error)
        }
    }
}
