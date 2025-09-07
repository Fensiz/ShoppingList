//
//  AppTextField.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 04.09.2025.
//

import SwiftUI

struct AppTextField: View {
	@Binding var text: String

	var body: some View {
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
				AppTextField(text: .constant("123"))
				AppTextField(text: $text)
			}
		}
	}
}
#Preview {
	PreviewWrapper()
}
