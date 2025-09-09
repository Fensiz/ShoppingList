//
//  ProductEditView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 09.09.2025.
//

import SwiftUI

struct ProductEditView: View {
	@State var name: String = ""
	@State var unit: Unit = .piece
	@State var count: Int?
	@State var countText: String = ""
	let saveAction: () -> Void
	let cancelAction: () -> Void

	var isValid: Bool {
		!name.isEmpty && Int(countText) != nil
	}

	var body: some View {
		VStack(spacing: 12) {
			RoundedRectangle(cornerRadius: 3)
				.fill(Color.gray.opacity(0.4))
				.frame(width: 36, height: 5)
				.padding(.top, 4)
			VStack(spacing: 20) {
				HStack {
					Button {

					} label: {
						Text("Отменить")
							.font(.appBody)
							.foregroundStyle(.greyHint)
					}
					Spacer()

					Text("Создание товара")
						.font(.appSemibold)
					Spacer()
					Button {

					} label: {
						Text("Готово")
							.font(isValid ? .appSemibold : .appBody)
							.foregroundStyle(isValid ? .turtoise : .greyHint)
					}
					.disabled(!isValid)
				}
				AppTextField(text: $name, placeholder: "Название товара")
				HStack {
					AppTextField(
						text: $countText,
						state: .normal,
						numbersOnly: true,
						placeholder: "Количество"
					)
					AppUnitPicker(selectedUnit: $unit)
				}
			}
		}
		.padding(.horizontal, 16)
		Spacer()
	}
}

private struct PreviewWrapper: View {
	@State var showSheet: Bool = false
	var body: some View {
		Button("123") {
			showSheet.toggle()
		}
		.sheet(isPresented: $showSheet, content: {
			ProductEditView {}
			cancelAction: {}
		})
	}
}

#Preview {
	PreviewWrapper()
}
