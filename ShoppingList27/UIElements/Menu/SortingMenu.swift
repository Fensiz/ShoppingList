//
//  SortingMenu.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 12.09.2025.
//

import SwiftUI

struct SortingMenu: View {
	@Binding var isSortedByName: Bool

	var body: some View {
		Menu {
			Picker(selection: $isSortedByName) {
				Text("Сортировка по имени").tag(true)
			} label: {
				Text("Сортировка по имени")
			}
		} label: {
			Image(systemName: "arrow.up.arrow.down")
		}
		.pickerStyle(.menu)
	}
}

#Preview {
	SortingMenu(isSortedByName: .constant(true))
}
