//
//  AppButton.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 03.09.2025.
//

import SwiftUI

struct AppButton: View {
	let title: String
	let action: () -> Void
	var body: some View {
		Button(title, action: action)
			.buttonStyle(
				AppButtonStyle(
					normalColor: .turtoise,
					pressedColor: .pressed
				)
			)
	}
}

#Preview {
	AppButton(title: "Сохранить") {}
	AppButton(title: "Сохранить") {}.disabled(true)
}

struct AppButtonStyle: ButtonStyle {
	var normalColor: Color
	var pressedColor: Color
	var disabledColor: Color = .greyButton

	@Environment(\.isEnabled) private var isEnabled

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.appHeadline)
			.frame(height: 44)
			.frame(maxWidth: .infinity)
			.background(
				isEnabled
				? (configuration.isPressed ? pressedColor : normalColor)
				: disabledColor
			)
			.foregroundColor(.white)
			.cornerRadius(22)
	}
}
