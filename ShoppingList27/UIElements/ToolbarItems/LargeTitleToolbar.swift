//
//  LargeTitleToolbar.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 08.09.2025.
//

import SwiftUI

struct LargeTitleToolbar: ToolbarContent {
	let title: String

	var body: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			Text(title)
				.font(.title1SemiBold)
		}
	}
}
