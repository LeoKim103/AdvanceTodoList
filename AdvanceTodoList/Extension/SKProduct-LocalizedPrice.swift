//
//  SKProduct-LocalizedPrice.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 14/10/2021.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
