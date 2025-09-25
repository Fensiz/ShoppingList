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

extension ListItemModel: Codable {
	enum CodingKeys: String, CodingKey {
		case name
		case products
		case logoImageName
		case logoColorHex
	}

	convenience init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		let name = try container.decode(String.self, forKey: .name)
		let logoImageName = try container.decode(String.self, forKey: .logoImageName)
		let logoColorHex = try container.decode(String.self, forKey: .logoColorHex)
		let products = try container.decode([ProductItemModel].self, forKey: .products)

		self.init(
			logo: ItemLogo(imageName: logoImageName, colorHex: logoColorHex),
			name: name,
			products: products
		)
		self.products.forEach { $0.list = self }
	}

	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(name, forKey: .name)
		try container.encode(products, forKey: .products)
		try container.encode(logoImageName, forKey: .logoImageName)
		try container.encode(logoColorHex, forKey: .logoColorHex)
	}
}
