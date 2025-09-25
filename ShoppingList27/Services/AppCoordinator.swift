//
//  AppCoordinator.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 05.09.2025.
//

import SwiftUI
import Combine

protocol AppCoordinatorProtocol: AnyObject {
	func goBack()
	func finishOnboarding()
	func openShoppingListsScreen()
	func openProductCreationScreen(
		list: ListItemModel,
		action: @escaping (ProductItemModel) -> Void,
		checkExistance: @escaping (String) -> Bool
	)
	func openShoppingListScreen(with item: ListItemModel)
	func openShoppingListCreationScreen(
		action: @escaping (ListItemModel) -> Void,
		checkExistance: @escaping (String) -> Bool
	)
	func openShoppingListEditScreen(
		with item: ListItemModel,
		action: @escaping () -> Void,
		checkExistance: @escaping (String) -> Bool
	)
	func openShoppingListCopyScreen(
		with item: ListItemModel,
		action: @escaping (ListItemModel) -> Void,
		checkExistance: @escaping (String) -> Bool
	)
}

@Observable final class AppCoordinator: AppCoordinatorProtocol {
	enum Screen: Hashable {
		case shoppingListCreation(
			action: (ListItemModel) -> Void,
			checkExistance: (String) -> Bool
		)
		case shoppingListEdit(
			item: ListItemModel,
			action: () -> Void,
			checkExistance: (String) -> Bool
		)
		case shoppingListCopy(
			item: ListItemModel,
			action: (ListItemModel) -> Void,
			checkExistance: (String) -> Bool
		)
		case shoppingList(item: ListItemModel)

		case productCreation(
			list: ListItemModel,
			action: (ProductItemModel) -> Void,
			checkExistance: (String) -> Bool
		)
		case productEdit(
			item: ProductItemModel,
			action: (ProductItemModel) -> Void,
			checkExistance: (String) -> Bool
		)
		case shoppingLists(themeProvider: any AppThemeProvider)

		static func == (lhs: Screen, rhs: Screen) -> Bool {
			switch (lhs, rhs) {
			case (.shoppingListCreation, .shoppingListCreation):
				true
			case let (.shoppingListEdit(item1, _, _), .shoppingListEdit(item2, _, _)):
				item1 == item2
			case let (.shoppingListCopy(item1, _, _), .shoppingListCopy(item2, _, _)):
				item1 == item2
			case let (.shoppingList(item1), .shoppingList(item2)):
				item1 == item2
			case (.shoppingLists, .shoppingLists):
				true
			default:
				false
			}
		}

		func hash(into hasher: inout Hasher) {
			switch self {
			case .shoppingListCreation:
				hasher.combine(0)
			case let .shoppingListEdit(item, _, _):
				hasher.combine(1)
				hasher.combine(item)
			case let .shoppingListCopy(item, _, _):
				hasher.combine(2)
				hasher.combine(item)
			case let .shoppingList(item):
				hasher.combine(3)
				hasher.combine(item)
			case .productCreation:
				hasher.combine(4)
			case let .productEdit(item, _, _):
				hasher.combine(5)
				hasher.combine(item)
			case .shoppingLists:
				hasher.combine(6)
			}
		}
	}

	static let key = "didFinishOnboarding24"
	var onMainScreenAppear: (() -> Void)?
	var isOnboardingShowing: Bool
	var navigationPath: [Screen] = []
	var rootScreen: Screen!

	init() {
		isOnboardingShowing = !UserDefaults.standard.bool(forKey: AppCoordinator.key)
	}

	func goBack() {
		_ = navigationPath.popLast()
	}

	func finishOnboarding() {
		isOnboardingShowing = false
		UserDefaults.standard.setValue(true, forKey: AppCoordinator.key)
	}

	func openShoppingListsScreen() {
		navigationPath.removeAll()
		onMainScreenAppear?()
	}

	func openProductCreationScreen(
		list: ListItemModel,
		action: @escaping (ProductItemModel) -> Void,
		checkExistance: @escaping (String) -> Bool
	) {
		navigationPath.append(.productCreation(list: list, action: action, checkExistance: checkExistance))
	}

	func openShoppingListScreen(with item: ListItemModel) {
		navigationPath.append(.shoppingList(item: item))
	}

	func openShoppingListCreationScreen(
		action: @escaping (ListItemModel) -> Void,
		checkExistance: @escaping (String) -> Bool
	) {
		navigationPath.append(
			.shoppingListCreation(
				action: action,
				checkExistance: checkExistance
			)
		)
	}

	func openShoppingListEditScreen(
		with item: ListItemModel,
		action: @escaping () -> Void,
		checkExistance: @escaping (String) -> Bool
	) {
		navigationPath.append(
			.shoppingListEdit(
				item: item,
				action: action,
				checkExistance: checkExistance
			)
		)
	}

	func openShoppingListCopyScreen(
		with item: ListItemModel,
		action: @escaping (ListItemModel) -> Void,
		checkExistance: @escaping (String) -> Bool
	) {
		navigationPath.append(
			.shoppingListCopy(
				item: item,
				action: action,
				checkExistance: checkExistance
			)
		)
	}
}
