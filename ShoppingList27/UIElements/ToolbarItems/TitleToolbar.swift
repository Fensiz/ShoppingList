//
//  ListTitleToolbar.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 08.09.2025.
//

import SwiftUI

struct TitleToolbar: ToolbarContent {
	let title: String

	var body: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			Text(title)
				.font(.appHeadline)
		}
	}
}
