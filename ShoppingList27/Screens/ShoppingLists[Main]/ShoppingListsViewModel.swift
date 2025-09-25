//
//  ShoppingListsViewModel.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 12.09.2025.
//

import SwiftUI

@MainActor @Observable final class ShoppingListsViewModel {
	var list: [ListItemModel] = []
	var isAlertPresented: Bool = false
	private let dataSource: any ListItemDataSourceProtocol
	private var itemForDeletion: ListItemModel?
	private(set) var sortState: Bool {
		get {
			UserDefaults.standard.bool(forKey: "isSortedByName")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "isSortedByName")
		}
	}

	init(dataSource: any ListItemDataSourceProtocol) {
		self.dataSource = dataSource
		updateList()
	}

	func toggleSortState() {
		sortState.toggle()
		updateList()
	}

	func confirmDeletion() {
		guard let itemForDeletion else { return }
		withAnimation {
			removeItem(itemForDeletion)
		}
		self.itemForDeletion = nil
	}
	func cancelDeletion() {
		self.itemForDeletion = nil
	}

	func showDeletionAlert(for item: ListItemModel) {
		itemForDeletion = item
		isAlertPresented = true
	}

	func isItemExist(with name: String) -> Bool {
		list.contains(where: { $0.name == name })
	}

	func addNewItem(_ item: ListItemModel) {
		dataSource.insert(item)
		updateList()
	}

	func updateItem() {
		dataSource.applyChanges()
	}

	private func removeItem(_ item: ListItemModel) {
		dataSource.delete(item)
		updateList()
	}

	func updateList() {
		Task {
			list = dataSource.fetchListItems(sortedByName: sortState)
		}
	}
}

struct ShareSheet: UIViewControllerRepresentable {
	let items: [Any]

	func makeUIViewController(context: Context) -> UIActivityViewController {
		UIActivityViewController(activityItems: items, applicationActivities: nil)
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
