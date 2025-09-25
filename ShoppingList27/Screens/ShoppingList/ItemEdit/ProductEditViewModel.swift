//
//  ProductEditViewModel.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 13.09.2025.
//

import SwiftUI

@MainActor @Observable final class ProductEditViewModel {
	enum Mode {
		case add
		case edit
	}
	var name: String {
		didSet {
			print("NAME_CHANGE: \(name)")
			withAnimation {
				fetchOptions()
			}
		}
	}
	var isItemNameUnique: Bool {
		guard let isExistCheckAction else { return true }
		if let originalName = originalItem?.name {
			return name == originalName || !isExistCheckAction(name)
		} else {
			return !isExistCheckAction(name)
		}
	}
	var isDoneButtonEnabled: Bool {
		!name.isEmpty &&
		Int(countText) != nil &&
		isItemNameUnique
	}
	var viewTitle: String {
		originalItem != nil ? "Редактировать" : "Создание товара"
	}
	var unit: Unit
	var countText: String
	var isOptionsShown: Bool = false
	var options: [String] = []
	var isInTextField: Bool = false
	private let originalItem: ProductItemModel?
	private let list: ListItemModel
	private let saveAction: ((ProductItemModel) -> Void)?
	private let cancelAction: (() -> Void)?
	private let isExistCheckAction: ((String) -> Bool)?
	private let fetchAction: ((ListItemModel, String) async -> [String])?

	init(
		item: ProductItemModel? = nil,
		list: ListItemModel,
		saveAction: ((ProductItemModel) -> Void)? = nil,
		cancelAction: (() -> Void)? = nil,
		isExistCheckAction: ((String) -> Bool)? = nil,
		fetchAction: ((ListItemModel, String) async -> [String])? = nil
	) {
		originalItem = item
		if let item {
			self.name = item.name
			self.unit = item.unit
			self.countText = "\(item.count)"
		} else {
			self.name = ""
			self.unit = .piece
			self.countText = ""
		}
		self.list = list
		self.saveAction = saveAction
		self.cancelAction = cancelAction
		self.isExistCheckAction = isExistCheckAction
		self.fetchAction = fetchAction
	}

	func apply(_ option: String) {
		hideOptions()
		name = option
	}

	func cancel() {
		cancelAction?()
	}

	func save() {
		guard let count = Int(countText) else { return }
		if let originalItem {
			originalItem.name = name
			originalItem.count = count
			originalItem.unit = unit
			saveAction?(originalItem)
		} else {
			let item = ProductItemModel(name: name, list: list, count: count, unit: unit)
			saveAction?(item)
		}
	}

	func enterTextField() {
		isInTextField = true
		fetchOptions()
	}

	func hideOptions() {
		isOptionsShown = false
		isInTextField = false
	}

	private func fetchOptions() {
		guard isInTextField else { return }
		let list = self.list
		if !name.isEmpty {
			Task {
				options = await fetchAction?(list, name) ?? []
			}
			if !options.isEmpty {
				isOptionsShown = true
			}
		} else {
			isOptionsShown = false
			options = []
		}
	}
}
