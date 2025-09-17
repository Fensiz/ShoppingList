//
//  ShoppingList27App.swift
//  ShoppingList27
//
//  Created by Nikita Tsomuk on 01.09.2025.
//

import SwiftUI
import SwiftData

enum AppTheme: String, CaseIterable {
	case light, dark, system
}

@main
struct ShoppingList27App: App {
	@State private var coordinator = AppCoordinator()
	@AppStorage("appTheme") private var appTheme: AppTheme = AppTheme.system

	init() {

		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.shadowColor = .clear
		appearance.backgroundColor = .screenBackground
		appearance.largeTitleTextAttributes = [
			.font: UIFont(name: "Rubik-SemiBold", size: 32)!,
			.foregroundColor: UIColor.appText
		]
		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
		UINavigationBar.appearance().compactAppearance = appearance

		UIView.appearance(
			whenContainedInInstancesOf: [UIAlertController.self]
		).tintColor = .turtoise
	}
	
	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			ListItemModel.self,
			ProductItemModel.self
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()

	var body: some Scene {
		WindowGroup {
			NavigationStack(path: $coordinator.navigationPath) {
				let dataSource = ListItemDataSource(context: sharedModelContainer.mainContext)
				let viewModel = ShoppingListsViewModel(dataSource: dataSource)
				ShoppingListsView(viewModel: viewModel, appTheme: $appTheme)
					.navigationDestination(for: AppCoordinator.Screen.self) { screen in
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
						}
					}
			}
			.modelContainer(sharedModelContainer)
			.environment(coordinator)
			.fullScreenCover(
				isPresented: $coordinator.isOnboardingShowing
			) {
				OnboardingView {
					coordinator.finishOnboarding()
				}
			}
			.preferredColorScheme(
				appTheme == .system ? nil :
					appTheme == .light ? .light : .dark
			)
			.onOpenURL { url in
				if url.pathExtension == "shoppinglist" {
					importShoppingList(from: url)
				}
			}
		}
	}

	private func importShoppingList(from url: URL) {
		do {
			let data = try Data(contentsOf: url)
			let decoded = try JSONDecoder().decode(ListItemModel.self, from: data)

			let dataSource = ListItemDataSource(context: sharedModelContainer.mainContext)
			try dataSource.safeInsert(decoded)
			coordinator.openShoppingListsScreen()

			print("Импортирован список: \(decoded.name)")
		} catch {
			print("Ошибка импорта: \(error)")
		}
	}
}
