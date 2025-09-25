//
//  ScreenFactory.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 20.09.2025.
//

import SwiftUI
import SwiftData

struct ScreenFactory {
	let sharedModelContainer: ModelContainer
	let coordinator: any AppCoordinatorProtocol

	@MainActor
	@ViewBuilder
	func makeView(for screen: AppCoordinator.Screen) -> some View {
		switch screen {
		case .shoppingList(let item):
			let dataSource = ProductItemDataSource(context: sharedModelContainer.mainContext)
			let viewModel = ShoppingListViewModel(list: item, dataSource: dataSource)
			ShoppingListView(viewModel: viewModel)
		case .shoppingListEdit(let item, let action, let checkExistance):
			let viewModel = ListItemModificationViewModel(
				listItem: item,
				mode: .edit(onSave: action),
				checkExistance: checkExistance
			)
			ListItemModificationView(viewModel: viewModel)
		case let .shoppingListCopy(item, action, checkExistance):
			let viewModel = ListItemModificationViewModel(
				listItem: item,
				mode: .add(onSave: action),
				checkExistance: checkExistance
			)
			ListItemModificationView(viewModel: viewModel)
		case let .shoppingListCreation(action, checkExistance):
			let viewModel = ListItemModificationViewModel(
				mode: .add(onSave: action),
				checkExistance: checkExistance
			)
			ListItemModificationView(viewModel: viewModel)
		case let .productCreation(list, action, checkExistance):
			let viewModel = ProductEditViewModel(
				list: list,
				saveAction: action,
				cancelAction: coordinator.goBack,
				isExistCheckAction: checkExistance
			)
			ProductEditView(viewModel: viewModel)
		case .productEdit:
			EmptyView()
		case .shoppingLists(var appThemeProvider):
			let dataSource = ListItemDataSource(context: sharedModelContainer.mainContext)
			let viewModel = ShoppingListsViewModel(dataSource: dataSource)
			ShoppingListsView(viewModel: viewModel, appTheme: Binding(get: {
				appThemeProvider.appTheme
			}, set: { newValue in
				appThemeProvider.appTheme = newValue
			}))
		}
	}
}
