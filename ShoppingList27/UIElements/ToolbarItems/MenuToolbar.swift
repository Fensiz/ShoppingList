//
//  MenuToolbar.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 08.09.2025.
//

import SwiftUI

struct MenuToolbar: ToolbarContent {
	private let actions: [MenuElement]

	init(@MenuBuilder _ content: () -> [MenuElement]) {
		self.actions = content()
	}

	var body: some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			Menu {
				ForEach(Array(actions.enumerated()), id: \.offset) { _, action in
					action.button
				}
			} label: {
				Image(.ellipsisDots)
					.foregroundColor(.appSystemIcon)
					.padding(10)
			}
		}
	}
}
