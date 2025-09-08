//
//  AppTextField.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 04.09.2025.
//

import SwiftUI

struct AppTextField: View {
	enum AppTextFieldState {
		case normal
		case error(String)
		var isError: Bool {
			if case .error = self {
				return true
			}
			return false
		}
	}

	@Binding var text: String
	let state: AppTextFieldState

	init(text: Binding<String>, state: AppTextFieldState = .normal) {
		self._text = text
		self.state = state
	}

	var body: some View {
		VStack(spacing: 4) {
			HStack {
				PlaceholderTextField(
					text: $text,
					placeholder: "Введите название списка",
					placeholderColor: .greyHint
				)
				.font(.appBody)
				.foregroundStyle(.appText)
				if !text.isEmpty {
					Button {
						text = ""
					} label: {
						Image(.circleCross)
							.foregroundColor(.greyHint)
					}
				}
			}
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

private struct PlaceholderTextField: View {
	@Binding var text: String
	let placeholder: String
	let placeholderColor: Color

	var body: some View {
		ZStack(alignment: .leading) {
			if text.isEmpty {
				Text(placeholder)
					.foregroundColor(placeholderColor)
			}
			TextField("", text: $text)
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
				AppTextField(text: $text, state: text == "123" ? .error("Ошибка") : .normal)
			}
		}
	}
}
#Preview {
	PreviewWrapper()
}
