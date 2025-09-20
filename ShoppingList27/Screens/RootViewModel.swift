//
//  RootViewModel.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 20.09.2025.
//

import SwiftUI

protocol AppThemeProvider {
	var appTheme: AppTheme { get set }
}

@Observable final class RootViewModel: AppThemeProvider {
	var appTheme: AppTheme {
		get {
			access(keyPath: \.appTheme)
			if let rawValue = UserDefaults.standard.string(forKey: "appTheme"),
			   let theme = AppTheme(rawValue: rawValue) {
				return theme
			}
			return .system
		}
		set {
			withMutation(keyPath: \.appTheme) {
				UserDefaults.standard.setValue(newValue.rawValue, forKey: "appTheme")
			}
		}
	}
	var colorScheme: ColorScheme? {
		appTheme == .system ? nil : appTheme == .light ? .light : .dark
	}
	private let dataSource: any ListItemDataSourceProtocol
	private let coordinator: any AppCoordinatorProtocol

	init(dataSource: any ListItemDataSourceProtocol, coordinator: any AppCoordinatorProtocol) {
		self.dataSource = dataSource
		self.coordinator = coordinator
	}

	@MainActor func handleOpenUrl(_ url: URL) {
		if url.pathExtension == "shoppinglist" {
			importShoppingList(from: url)
		}
	}

	@MainActor private func importShoppingList(from url: URL) {
		do {
			let data = try Data(contentsOf: url)
			let decoded = try JSONDecoder().decode(ListItemModel.self, from: data)

			try dataSource.safeInsert(decoded)
			coordinator.openShoppingListsScreen()

			print("Импортирован список: \(decoded.name)")
		} catch {
			print("Ошибка импорта: \(error)")
		}
	}
}
