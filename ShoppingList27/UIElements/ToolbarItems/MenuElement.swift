//
//  MenuElement.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 08.09.2025.
//

import SwiftUI

enum MenuElement: Hashable {
	case sortByName(() -> Void)
	case share(() -> Void)
	case uncheckAll(() -> Void)
	case deleteBought(() -> Void)
	case themeSelector(Binding<AppTheme>)

	func hash(into hasher: inout Hasher) {
		switch self {
		case .sortByName: hasher.combine("sortByName")
		case .share: hasher.combine("share")
		case .uncheckAll: hasher.combine("uncheckAll")
		case .deleteBought: hasher.combine("deleteBought")
		case .themeSelector: hasher.combine("themeSelector")
		}
	}

	static func == (lhs: MenuElement, rhs: MenuElement) -> Bool {
		switch (lhs, rhs) {
		case (.sortByName, .sortByName),
			 (.share, .share),
			 (.uncheckAll, .uncheckAll),
			 (.deleteBought, .deleteBought),
			 (.themeSelector, .themeSelector):
			return true
		default:
			return false
		}
	}

	@ViewBuilder
	var button: some View {
		switch self {
		case .sortByName(let action):
			Button(action: action) {
				Label("Сортировать\nпо Алфавиту", systemImage: "arrow.up.arrow.down")
			}
		case .share(let action):
			Button(action: action) {
				Label("Поделиться", systemImage: "square.and.arrow.up")
			}
		case .uncheckAll(let action):
			Button(action: action) {
				Label("Снять отметки со\nвсех товаров", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
			}
		case .deleteBought(let action):
			Button(role: .destructive, action: action) {
				Label("Удалить купленные товары", systemImage: "trash")
			}
		case .themeSelector(let appTheme):
			Picker(selection: appTheme) {
				Text("Светлая").tag(AppTheme.light)
				Text("Темная").tag(AppTheme.dark)
				Text("Системная").tag(AppTheme.system)
			} label: {
				Label("Установить тему", image: .contrast)
			}
			.pickerStyle(.menu)
		}
	}
}
