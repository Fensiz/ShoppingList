//
//  AppCoordinator.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 05.09.2025.
//

import SwiftUI
import Combine

@Observable final class AppCoordinator {
	static let key = "didFinishOnboarding24"

	var isOnboardingShowing: Bool

	var navigationPath: [Screen] = []

	enum Screen: Hashable {
		case shoppingListCreation(
			action: (ListItemModel) -> Void,
			checkExistance: (String) -> Bool
		)
		case shoppingListEdit(
			item: ListItemModel,
			action: (ListItemModel) -> Void,
			checkExistance: (String) -> Bool
		)
		case shoppingListCopy(
			item: ListItemModel,
			action: (ListItemModel) -> Void,
			checkExistance: (String) -> Bool
		)
		case shoppingList(item: ListItemModel)

		static func ==(lhs: Screen, rhs: Screen) -> Bool {
			switch (lhs, rhs) {
			case (.shoppingListCreation, .shoppingListCreation):
				return true
			case let (.shoppingListEdit(item1, _, _), .shoppingListEdit(item2, _, _)):
				return item1 == item2
			case let (.shoppingListCopy(item1, _, _), .shoppingListCopy(item2, _, _)):
				return item1 == item2
			case let (.shoppingList(item1), .shoppingList(item2)):
				return item1 == item2
			default:
				return false
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
			}
		}
	}

	init() {
		isOnboardingShowing = !UserDefaults.standard.bool(forKey: AppCoordinator.key)
	}

	func start() {

	}

	func finishOnboarding() {
		isOnboardingShowing = false
		UserDefaults.standard.setValue(true, forKey: AppCoordinator.key)
	}

	func openShoppingListsScreen() {
		navigationPath.removeAll()
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
		action: @escaping (ListItemModel) -> Void,
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


//@ObservationIgnored
//var didFinishOnboarding: Bool {
//	get {
//		access(keyPath: \.didFinishOnboarding)
//		return UserDefaults.standard.bool(forKey: AppCoordinator.key)
//	}
//	set {
//		withMutation(keyPath: \.didFinishOnboarding) {
//			UserDefaults.standard.setValue(newValue, forKey: AppCoordinator.key)
//			print(newValue)
//		}
//	}
//}
