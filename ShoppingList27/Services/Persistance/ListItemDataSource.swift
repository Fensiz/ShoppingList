//
//  ListItemDataSource.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 12.09.2025.
//

import SwiftData
import SwiftUI

@MainActor protocol ListItemDataSourceProtocol {
	func insert(_ entity: ListItemModel)
	func delete(_ entity: ListItemModel)
	func applyChanges()
	func fetchListItems(sortedByName: Bool) -> [ListItemModel]
	func safeInsert(_ entity: ListItemModel) throws
}

@MainActor final class ListItemDataSource: ListItemDataSourceProtocol {
	private let container: ModelContainer?
	private let context: ModelContext?

	init(container: ModelContainer? = nil, context: ModelContext? = nil) {
		self.container = container
		self.context = context
	}
}

extension ListItemDataSource {
	func insert(_ entity: ListItemModel) {
		self.context?.insert(entity)
		try? self.context?.save()
	}

	func applyChanges() {
		try? self.context?.save()
	}

	func safeInsert(_ entity: ListItemModel) throws {
		guard !isItemExist(entity) else {
			throw NSError(domain: "ListItemDataSource",
						  code: 1,
						  userInfo: [NSLocalizedDescriptionKey: "Список с таким именем уже существует"])
		}
		insert(entity)
	}

	func delete(_ entity: ListItemModel) {
		self.context?.delete(entity)
		try? self.context?.save()
	}

	func fetchListItems(sortedByName: Bool) -> [ListItemModel] {
		let descriptor: FetchDescriptor<ListItemModel>

		if sortedByName {
			descriptor = FetchDescriptor<ListItemModel>(
				sortBy: [.init(\.name, order: .forward)]
			)
		} else {
			descriptor = FetchDescriptor<ListItemModel>(
//				sortBy: [.init(\.createdAt, order: .forward)]
			)
		}

		let items = try? context?.fetch(descriptor)
		return items ?? []
	}

	private func isItemExist(_ entity: ListItemModel) -> Bool {
		let fetchDescriptor = FetchDescriptor<ListItemModel>(
			predicate: #Predicate { $0.name == entity.name }
		)

		return (try? context?.fetch(fetchDescriptor))?.isEmpty == false
	}
}
