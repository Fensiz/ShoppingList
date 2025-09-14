//
//  ItemLogo.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 03.09.2025.
//

import SwiftUI

struct ItemLogo: Hashable {
	let imageName: String
	let color: Color

	init(imageName: String, color: Color) {
		self.imageName = imageName
		self.color = color
	}

	init(imageName: String, colorHex: String) {
		self.imageName = imageName
		self.color = Color(hex: colorHex)
	}
	
	static let mock1 = ItemLogo(imageName: "paw", color: .extraRed)
}
