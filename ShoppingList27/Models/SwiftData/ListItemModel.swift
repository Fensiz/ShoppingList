//
//  ListItemModel.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 12.09.2025.
//

import SwiftData
import Foundation

@Model
final class ListItemModel {
	@Attribute(.unique)
	var name: String
	@Relationship(deleteRule: .cascade)
	var products: [ProductItemModel]
	@Transient
	var count: Int { products.filter(\.isBought).count }
	@Transient
	var total: Int { products.count }
	@Transient
	var logo: ItemLogo {
		get {
			ItemLogo(
				imageName: logoImageName,
				colorHex: logoColorHex
			)
		}
		set {
			logoImageName = newValue.imageName
			logoColorHex = newValue.color.toHex()
		}
	}
//	var created: Date
	private var logoImageName: String
	private var logoColorHex: String

	init(
		logo: ItemLogo,
		name: String,
		products: [ProductItemModel] = []
	) {
		logoImageName = logo.imageName
		logoColorHex = logo.color.toHex()
		self.name = name
		self.products = products
//		created = .now
	}
}
