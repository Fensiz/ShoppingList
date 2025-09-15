//
//  ProductItemModel.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 12.09.2025.
//

import SwiftData
import Foundation

@Model
final class ProductItemModel {
	var name: String
	@Relationship(deleteRule: .nullify, inverse: \ListItemModel.products)
	var list: ListItemModel?
	var isBought: Bool = false
	var count: Int
	@Transient
	var unit: Unit {
		get { Unit(rawValue: unitRaw) ?? .piece }
		set { unitRaw = newValue.rawValue }
	}
//	var createdAt: Date
	private var unitRaw: String

	init(
		name: String,
		list: ListItemModel?,
		count: Int,
		unit: Unit
	) {
		self.name = name
		self.list = list
		self.count = count
		self.unitRaw = unit.rawValue
//		createdAt = .now
	}
}

extension ProductItemModel: Codable {
	enum CodingKeys: String, CodingKey {
		case name
		case isBought
		case count
		case unitRaw
	}

	convenience init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let name = try container.decode(String.self, forKey: .name)
		let isBought = try container.decode(Bool.self, forKey: .isBought)
		let count = try container.decode(Int.self, forKey: .count)
		let unitRaw = try container.decode(String.self, forKey: .unitRaw)

		self.init(
			name: name,
			list: nil,
			count: count,
			unit: Unit(rawValue: unitRaw) ?? .piece
		)
		self.isBought = isBought
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(isBought, forKey: .isBought)
		try container.encode(count, forKey: .count)
		try container.encode(unitRaw, forKey: .unitRaw)
	}
}
