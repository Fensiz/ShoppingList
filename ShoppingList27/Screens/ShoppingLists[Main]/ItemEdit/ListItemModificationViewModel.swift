//
//  ListItemModificationViewModel.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 07.09.2025.
//

import SwiftUI

@Observable final class ListItemModificationViewModel {
	enum Mode: Equatable {
		case add(onSave: ((ListItemModel) -> Void)?)
		case edit(onSave: (() -> Void)?)

		static func == (lhs: Mode, rhs: Mode) -> Bool {
			switch (lhs, rhs) {
			case (.add, .add):
				return true
			case (.edit, .edit):
				return true
			default:
				return false
			}
		}
	}
	let originalItem: ListItemModel?
	var listName: String = ""
	var selectedColor: Color?
	var selectedLogo: String?
	let checkExistance: ((String) -> Bool)
	let mode: Mode

	var isNewItem: Bool {
		originalItem == nil
	}

	var isItemNameUnique: Bool {
		switch (originalItem, mode) {
		case (let item?, .edit):
			listName == item.name || !checkExistance(listName)
		default:
			!checkExistance(listName)
		}
	}

	var isSaveDisabled: Bool {
		listName.isEmpty ||
		selectedColor == nil ||
		selectedLogo == nil ||
		!isItemNameUnique
	}

	init(
		listItem: ListItemModel? = nil,
		mode: Mode,
		checkExistance: @escaping ((String) -> Bool) = { _ in false }
	) {
		self.originalItem = listItem
		if let listItem {
			self.listName = listItem.name
			self.selectedColor = listItem.logo.color
			self.selectedLogo = listItem.logo.imageName
		}
		self.checkExistance = checkExistance
		self.mode = mode
	}

	func save() {
		guard let selectedLogo, let selectedColor else { return }
		switch (originalItem, mode) {
		case (let item?, .edit(let onSave)):
			item.logo = .init(imageName: selectedLogo, color: selectedColor)
			item.name = listName
			onSave?()
		case (_, .add(let onSave)):
			let item = ListItemModel(
				logo: .init(imageName: selectedLogo, color: selectedColor),
				name: listName,
				products: []
			)
			onSave?(item)
		default:
			print("Unknown state")
		}
	}
}
