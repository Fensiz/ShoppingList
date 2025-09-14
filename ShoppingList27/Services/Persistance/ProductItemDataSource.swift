//
//  ProductItemDataSourceProtocol.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 13.09.2025.
//

import SwiftUI
import SwiftData

@MainActor protocol ProductItemDataSourceProtocol {
	func insert(_ entity: ProductItemModel)
	func delete(_ entity: ProductItemModel)
	func fetchProducts(for list: ListItemModel, sortedByName: Bool) -> [ProductItemModel]
	func fetchOptions(for list: ListItemModel, startingWith prefix: String) -> [String]
	func deleteAllBought(for list: ListItemModel)
	func uncheckAll(for list: ListItemModel)
	func save()
}

@MainActor final class ProductItemDataSource: ProductItemDataSourceProtocol {

	private let context: ModelContext?

	init(context: ModelContext?) {
		self.context = context
	}

	func insert(_ entity: ProductItemModel) {
		context?.insert(entity)
		save()
	}

	func delete(_ entity: ProductItemModel) {
		context?.delete(entity)
		save()
	}

	func fetchProducts(for list: ListItemModel, sortedByName: Bool) -> [ProductItemModel] {
		guard let context else { return [] }
		do {
			let name = list.name
			let descriptor = FetchDescriptor<ProductItemModel>(
				predicate: #Predicate<ProductItemModel> { $0.list?.name == name },
				sortBy: sortedByName ? [.init(\.name, order: .forward)]
				: []//[.init(\.createdAt, order: .forward)]
			)
			return try context.fetch(descriptor)
		} catch {
			print("⚠️ Ошибка загрузки продуктов: \(error)")
			return []
		}
	}

	func deleteAllBought(for list: ListItemModel) {
		let products = fetchProducts(for: list, sortedByName: false)
		for product in products where product.isBought {
			context?.delete(product)
		}
		save()
	}

	func uncheckAll(for list: ListItemModel) {
		let products = fetchProducts(for: list, sortedByName: false)
		for product in products {
			product.isBought = false
		}
		save()
	}

	func save() {
		do {
			try context?.save()
		} catch {
			print("⚠️ Ошибка сохранения: \(error)")
		}
	}

	func fetchOptions(for list: ListItemModel, startingWith prefix: String) -> [String] {
		guard let context else { return [] }
		do {
			let name = list.name
			let descriptor = FetchDescriptor<ProductItemModel>(
				predicate: #Predicate { product in
					product.list?.name != name &&
					product.name.count >= prefix.count
				}
//				sortBy: [.init(\.name, order: .forward)]
			)
			let products = try context.fetch(descriptor)
			let names = Set(products.map { $0.name }.filter({$0.hasPrefix(prefix)}))
			print(names)
			return Array(names).sorted()
		} catch {
			print("⚠️ Ошибка загрузки продуктов: \(error)")
			return []
		}
	}
}
