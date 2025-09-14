//
//  ListItemDataSource.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 12.09.2025.
//

import SwiftData

@MainActor protocol ListItemDataSourceProtocol {
	func insert(_ entity: ListItemModel)
	func delete(_ entity: ListItemModel)
	func fetchListItems(sortedByName: Bool) -> [ListItemModel]
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
}
