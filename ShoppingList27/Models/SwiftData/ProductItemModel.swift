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
		list: ListItemModel,
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
