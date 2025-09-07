//
//  ListItem.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 03.09.2025.
//

import Foundation

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
