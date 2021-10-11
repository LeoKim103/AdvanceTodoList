//
//  Binding-OnChange.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
