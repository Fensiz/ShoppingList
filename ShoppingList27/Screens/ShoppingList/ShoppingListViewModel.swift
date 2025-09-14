//
//  ShoppingListViewModel.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 13.09.2025.
//

import SwiftUI

@MainActor @Observable final class ShoppingListViewModel {
	let list: ListItemModel
	var products: [ProductItemModel] = []
	var searchText: String = ""
	var filteredProducts: [Binding<ProductItemModel>] {
		products.compactMap { product in
			if searchText.isEmpty || product.name.localizedCaseInsensitiveContains(searchText) {
				return Binding(
					get: { product },
					set: { updated in
						if let index = self.products.firstIndex(where: { $0.name == product.name }) {
							self.products[index] = updated
						}
					}
				)
			} else {
				return nil
			}
		}
	}
	private(set) var sortState: Bool {
		get {
			UserDefaults.standard.bool(forKey: "isProductSortedByName")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "isProductSortedByName")
		}
	}
	var alertText: (title: String, message: String) = ("", "")
	var isAlertPresented: Bool = false
	var productForEdit: ProductItemModel?

	private let dataSource: any ProductItemDataSourceProtocol
	private var productForDeletion: ProductItemModel?

	init(
		list: ListItemModel,
		dataSource: any ProductItemDataSourceProtocol
	) {
		self.list = list
		self.dataSource = dataSource
		updateList()
	}

	func addProduct(_ product: ProductItemModel) {
		dataSource.insert(product)
		updateList()
	}

	func deleteProduct(_ product: ProductItemModel) {
		dataSource.delete(product)
		updateList()
	}

	func deleteAllBought() {
		dataSource.deleteAllBought(for: list)
		updateList()
		hideAlert()
	}

	func uncheckAll() {
		dataSource.uncheckAll(for: list)
		updateList()
	}

	func toggleSortState() {
		sortState.toggle()
		updateList()
	}

	private func updateList() {
		products = dataSource.fetchProducts(for: list, sortedByName: sortState)
	}

	func hideAlert() {
		isAlertPresented = false
		alertText = ("", "")
	}

	var isEditScreenPresented: Bool = false

	func openCreationScreen() {
		isEditScreenPresented = true
		productForEdit = nil
	}
	func openEditScreen(for product: ProductItemModel) {
		isEditScreenPresented = true
		productForEdit = product
	}

	func closeEditScreen() {
		isEditScreenPresented = false
	}

	func isFirstItem(_ item: ProductItemModel) -> Bool {
		guard !filteredProducts.isEmpty else { return false }
		return filteredProducts.first?.name.wrappedValue == item.name
	}

	func confirmProductDeletion() {
		if let productForDeletion {
			dataSource.delete(productForDeletion)
			self.productForDeletion = nil
		} else {
			dataSource.deleteAllBought(for: list)
		}
		updateList()
		hideAlert()
	}
	func cancelProductDeletion() {
		self.productForDeletion = nil
		hideAlert()
	}

	func showDeletionAlertForAllBoughtDeletion() {
		alertText = (
			title: "Удаление купленных товаров",
			message: "Вы действительно хотите удалить все купленные товары?"
		)
		isAlertPresented = true
	}

	func showDeletionAlert(for item: ProductItemModel) {
		alertText = (
			title: "Удаление товара",
			message: "Вы действительно хотите удалить товар?"
		)
		productForDeletion = item
		isAlertPresented = true
	}

	func checkExistance(of name: String) -> Bool {
		products.contains(where: { $0.name == name })
	}

	func save(_ product: ProductItemModel) {
		closeEditScreen()
		if productForEdit == nil {
			dataSource.insert(product)
		}
	}

	func sheetCloseCompetion() {
		updateList()
	}

	func fetchOptions(for list: ListItemModel, startingWith prefix: String) -> [String] {
		dataSource.fetchOptions(for: list, startingWith: prefix)
	}
}
