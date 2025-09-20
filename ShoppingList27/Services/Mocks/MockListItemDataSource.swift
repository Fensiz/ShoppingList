//
//  MockListItemDataSource.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 12.09.2025.
//

final class MockListItemDataSource: ListItemDataSourceProtocol {
	func safeInsert(_ entity: ListItemModel) throws {
		
	}
	
	func applyChanges() {
		
	}
	
	func fetchListItems(sortedByName: Bool) -> [ListItemModel] {
		items
	}
	
	var items: [ListItemModel] = [
		ListItemModel(logo: .mock1, name: "Some List")
	]
	func insert(_ entity: ListItemModel) {
		items.append(entity)
	}
	
	func delete(_ entity: ListItemModel) {
		items.removeAll { $0.name == entity.name }
	}
}
