//
//  AppSwipeAction.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 09.09.2025.
//

import SwiftUI

@MainActor enum AppSwipeAction {
	case delete(() -> Void)
	case edit(() -> Void)
	case copy(() -> Void)

	@ViewBuilder
	var button: some View {
		switch self {
		case .delete(let action):
			Button {
				action()
			} label: {
				Image(.trash)
			}
			.tint(.appSystemRed)
		case .edit(let action):
			Button {
				action()
			} label: {
				Image(.modify)
			}
			.tint(.appSystemGrey)
		case .copy(let action):
			Button {
				action()
			} label: {
				Image(.duplicate)
			}
			.tint(.appSystemOrange)
		}
	}
}

@resultBuilder
enum AppSwipeActionBuilder {
	static func buildBlock(_ components: AppSwipeAction...) -> [AppSwipeAction] {
		components
	}
}

extension View {
	func swipeActions(
		edge: HorizontalEdge = .trailing,
		allowsFullSwipe: Bool = false,
		@AppSwipeActionBuilder _ content: () -> [AppSwipeAction]
	) -> some View {
		self.swipeActions(edge: edge, allowsFullSwipe: allowsFullSwipe) {
			ForEach(Array(content().enumerated()), id: \.offset) { _, action in
				action.button
			}
		}
	}
}
