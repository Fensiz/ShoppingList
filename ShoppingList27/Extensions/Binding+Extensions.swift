//
//  Binding+Extensions.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 05.09.2025.
//

import SwiftUI

extension Binding where Value == Bool {
	var not: Binding<Bool> {
		Binding(
			get: { !self.wrappedValue },
			set: { self.wrappedValue = !$0 }
		)
	}
}
