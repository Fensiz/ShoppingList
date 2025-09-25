//
//  AppTextField.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 04.09.2025.
//

import SwiftUI
import Combine

struct AppTextField: View {
	enum AppTextFieldState {
		case normal
		case error(String)

		var isError: Bool {
			if case .error = self { true } else { false }
		}
	}

	@FocusState var isFocused: Bool
	@Binding var text: String
	let state: AppTextFieldState
	let numbersOnly: Bool
	let placeholder: String?

	init(
		text: Binding<String>,
		state: AppTextFieldState = .normal,
		numbersOnly: Bool = false,
		placeholder: String? = nil
	) {
		self._text = text
		self.state = state
		self.numbersOnly = numbersOnly
		self.placeholder = placeholder
	}

	var body: some View {
		VStack(spacing: 4) {
			HStack {
				TextField(
					placeholder ?? "",
					text: $text
				)
				.keyboardType(numbersOnly ? .numberPad : .default)
				.font(.appBody)
				.foregroundStyle(.appText)
				.focused($isFocused)
				.onReceive(Just(text)) { newValue in
					guard self.numbersOnly else { return }
					let filtered = newValue.filter { "0123456789".contains($0) }
					if filtered != newValue {
						self.text = filtered
					}
				}

				if !text.isEmpty && isFocused {
					Button { text = "" } label: {
						Image(.circleCross)
							.foregroundColor(.greyHint)
					}
					.transition(.opacity.combined(with: .scale))
				}
			}
			.animation(.default, value: isFocused)
			.padding(.horizontal, 16)
			.frame(height: 54)
			.background(.elementBackground)
			.clipShape(RoundedRectangle(cornerRadius: 12))
			.overlay(
				RoundedRectangle(cornerRadius: 12)
					.stroke(state.isError ? .appSystemRed : .clear, lineWidth: 0.5)
			)

			if case let .error(errorMessage) = state {
				Text(errorMessage)
					.foregroundColor(.appSystemRed)
					.font(.footnoteRegular)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.leading, 8)
			}
		}
	}
}

private struct PreviewWrapper: View {
	@State var text = ""
	var body: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			VStack {
				AppTextField(text: .constant("123"), state: .normal)
				AppTextField(text: $text, state: text == "123" ? .error("Ошибка") : .normal, placeholder: "Placeholder")
				AppTextField(text: $text, state: text == "123" ? .error("Ошибка") : .normal, numbersOnly: true, placeholder: "Placeholder")
			}
		}
	}
}

#Preview {
	PreviewWrapper()
}
