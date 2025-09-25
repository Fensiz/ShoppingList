//
//  RootView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 20.09.2025.
//

import SwiftUI

struct RootView: View {
	@State var viewModel: RootViewModel
	@State private var coordinator: AppCoordinator
	private var factory: ScreenFactory

	init(
		coordinator: AppCoordinator,
		factory: ScreenFactory,
		viewModel: RootViewModel
	) {
		self.coordinator = coordinator
		self.viewModel = viewModel
		self.factory = factory
	}

	var body: some View {
		NavigationStack(path: $coordinator.navigationPath) {
			factory.makeView(for: coordinator.rootScreen)
				.navigationDestination(for: AppCoordinator.Screen.self) { screen in
					factory.makeView(for: screen)
				}
		}
		.environment(coordinator)
		.fullScreenCover(isPresented: $coordinator.isOnboardingShowing) {
			OnboardingView {
				coordinator.finishOnboarding()
			}
		}
		.preferredColorScheme(viewModel.colorScheme)
		.onOpenURL(perform: viewModel.handleOpenUrl)
	}
}
