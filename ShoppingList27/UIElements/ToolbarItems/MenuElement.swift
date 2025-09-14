//
//  MenuElement.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 08.09.2025.
//

import SwiftUI

enum MenuElement: Hashable {
	case sortByName(() -> Void, Bool)
	case share(() -> Void)
	case uncheckAll(() -> Void)
	case deleteBought(() -> Void)
	case themeSelector(Binding<AppTheme>)

	func hash(into hasher: inout Hasher) {
		switch self {
		case .sortByName(_, let isOn):
			hasher.combine("sortByName")
			hasher.combine(isOn)
		case .share: hasher.combine("share")
		case .uncheckAll: hasher.combine("uncheckAll")
		case .deleteBought: hasher.combine("deleteBought")
		case .themeSelector: hasher.combine("themeSelector")
		}
	}

	static func == (lhs: MenuElement, rhs: MenuElement) -> Bool {
		switch (lhs, rhs) {
		case let (.sortByName(_, lState), .sortByName(_, rState)):
			return lState == rState
		case (.share, .share),
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
		case .sortByName(let action, let state):
			Button(action: action) {
				Label {
					Text("Сортировать\nпо Алфавиту")
				} icon: {
					Image(systemName: "arrow.up.arrow.down")
						.tint(state ? .turtoise : .primary)
				}
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
