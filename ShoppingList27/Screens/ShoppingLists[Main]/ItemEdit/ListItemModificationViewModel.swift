//
//  ListItemModificationViewModel.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 07.09.2025.
//

import SwiftUI

@Observable final class ListItemModificationViewModel {
	enum Mode {
		case add
		case edit
	}
	let originalItem: ListItemModel?
	var listName: String = ""
	var selectedColor: Color?
	var selectedLogo: String?
	let onSave: ((ListItemModel) -> Void)?
	let checkExistance: ((String) -> Bool)
	let mode: Mode

	var isNewItem: Bool {
		originalItem == nil
	}

	var isItemNameUnique: Bool {
		if let originalItem, mode == .edit {
			listName == originalItem.name || !checkExistance(listName)
		} else {
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
		mode: Mode = .add,
		onSave: ((ListItemModel) -> Void)? = nil,
		checkExistance: @escaping ((String) -> Bool) = { _ in false }
	) {
		self.originalItem = listItem
		if let listItem {
			self.listName = listItem.name
			self.selectedColor = listItem.logo.color
			self.selectedLogo = listItem.logo.imageName
		}
		self.onSave = onSave
		self.checkExistance = checkExistance
		self.mode = mode
	}

	func save() {
		guard let selectedLogo, let selectedColor else { return }
		let item = ListItemModel(
			logo: .init(imageName: selectedLogo, color: selectedColor),
			name: listName,
			products: []
		)

//		(
//			logo: .init(imageName: selectedLogo, color: selectedColor),
//			name: listName,
//			count: 0,
//			total: 0
//		)
		onSave?(item)
	}
}
