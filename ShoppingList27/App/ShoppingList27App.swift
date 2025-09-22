//
//  ShoppingList27App.swift
//  ShoppingList27
//
//  Created by Nikita Tsomuk on 01.09.2025.
//

import SwiftUI

@main
struct ShoppingList27App: App {
	let sharedModelContainer = SwiftDataStack.shared.container

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

	var body: some Scene {
		WindowGroup {
			let (coordinator, screenFactory, viewModel) = {
				let coordinator = AppCoordinator()
				let screenFactory = ScreenFactory(
					sharedModelContainer: sharedModelContainer,
					coordinator: coordinator
				)
				let viewModel = RootViewModel(
					dataSource: ListItemDataSource(
						context: sharedModelContainer.mainContext
					),
					coordinator: coordinator
				)
				coordinator.rootScreen = .shoppingLists(themeProvider: viewModel)
				return (coordinator, screenFactory, viewModel)
			}()
			RootView(
				coordinator: coordinator,
				factory: screenFactory,
				viewModel: viewModel
			)
		}
	}
}
