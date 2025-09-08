//
//  ListItem.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 03.09.2025.
//

import Foundation
import SwiftData

struct Product: Identifiable, Hashable {
	let name: String
	var count: Int
	var unit: Unit
	var isBought: Bool
	var id: String { name }

	static func == (lhs: Product, rhs: Product) -> Bool {
		lhs.name == rhs.name
	}
}

struct ListItem: Identifiable, Hashable {
	let logo: ItemLogo
	let name: String
	let count: Int
	let total: Int
	let id: UUID = .init()

	static let mock: ListItem = .init(
		logo: .init(imageName: "paw", color: .blue),
		name: "Новый год",
		count: 10,
		total: 20
	)
	static let mock2: ListItem = .init(
		logo: .init(imageName: "paw", color: .indigo),
		name: "Новый гоqwdpiojqwdoiwj[qoipjoqwijdpoqwidopijqwpoidjqwpoijqwoas" +
		"pijqpwoijfopqiwjfopiqwfpoiqjopfijqpoifjqwopifqwopijqwpoijqwopijqwopi" +
		"jfqwopijfqwpoijfoqpiwд",
		count: 10,
		total: 20
	)
	static let mock3: ListItem = .init(
		logo: .init(imageName: "paw", color: .indigo),
		name: "Нqwdqwовqwdqwый гоqwdpiojqwdoiwj[qoipjoqwijdpoqwidopijqwpoidjqwpoijqwoas" +
		"pijqpwoijfopqiwjfopiqwfpoiqjopfijqpoifjqwopifqwopijqwpoijqwopijqwopi" +
		"jfqwopijfqwpoijfoqpiwд",
		count: 10,
		total: 20
	)
}

//@Model
//final class ListItem2: Identifiable, Hashable {
//	var logo: ItemLogo
//	@Attribute(.unique)
//	var name: String
////	@Relationship(delete: .cascade, update: .cascade)
//	var products: [Product]
//	var id: String { name }
//
//	init(logo: ItemLogo, name: String, products: [Product]) {
//		self.logo = logo
//		self.name = name
//		self.products = products
//	}
//}
//
//
//@Model
//final class Product: Hashable {
//	@Attribute(.unique) var name: String
//	var count: Int
//	var unit: String
//	var isBought: Bool
//	var id: String { name }
//
//	init(name: String, count: Int, unit: String, isBought: Bool) {
//		self.name = name
//		self.count = count
//		self.unit = unit
//		self.isBought = isBought
//	}
//}
