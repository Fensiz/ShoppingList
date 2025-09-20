//
//  SwiftDataStack.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 20.09.2025.
//

import SwiftData

@MainActor final class SwiftDataStack {
	static let shared = SwiftDataStack()
	static let inMemory = SwiftDataStack(inMemory: true)

	let container: ModelContainer

	private init(inMemory: Bool = false) {
		let schema = Schema([
			ListItemModel.self,
			ProductItemModel.self
		])
		let config = ModelConfiguration(
			schema: schema,
			isStoredInMemoryOnly: inMemory
		)

		do {
			container = try ModelContainer(for: schema, configurations: [config])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}
}
