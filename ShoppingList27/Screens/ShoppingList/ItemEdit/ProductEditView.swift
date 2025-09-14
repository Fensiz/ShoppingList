//
//  ProductEditView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 09.09.2025.
//

import SwiftUI



struct ProductEditView: View {
	@State var viewModel: ProductEditViewModel
	@FocusState var isNameFocused: Bool

	var body: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			VStack(spacing: 12) {
				RoundedRectangle(cornerRadius: 2.5)
					.fill(Color.lightGrey)
					.frame(width: 36, height: 5)
					.padding(.top, 4)
				VStack(spacing: 20) {
					HStack {
						Button {
							viewModel.cancel()
						} label: {
							Text("Отменить")
								.font(.appBody)
								.foregroundStyle(.greyHint)
						}
						Spacer()
						Text(viewModel.viewTitle)
							.font(.appSemibold)
						Spacer()
						Button {
							viewModel.save()
						} label: {
							Text("Готово")
								.font(viewModel.isDoneButtonEnabled ? .appSemibold : .appBody)
								.foregroundStyle(viewModel.isDoneButtonEnabled ? .turtoise : .greyHint)
						}
						.disabled(!viewModel.isDoneButtonEnabled)
					}
					VStack(spacing: 10) {
						AppTextField(
							text: $viewModel.name,
							state: viewModel.isItemNameUnique ? .normal
							: .error("Этот товар уже есть в списке, добавьте другой."),
							placeholder: "Название товара",
						)
						.focused($isNameFocused)
						.onChange(of: isNameFocused, { oldValue, newValue in
							print(oldValue, newValue)
							if newValue {
								viewModel.enterTextField()
							} else {
								viewModel.hideOptions()
							}
						})
						ZStack {
							VStack(spacing: 0) {
								HStack {
									AppTextField(
										text: $viewModel.countText,
										state: .normal,
										numbersOnly: true,
										placeholder: "Количество"
									)
									AppUnitPicker(selectedUnit: $viewModel.unit)
								}
								.padding(.top, 10)
								Spacer()
							}
							if viewModel.isOptionsShown {
								List(viewModel.options, id: \.self) { option in
									Text(option)
										.frame(maxWidth: .infinity, alignment: .leading)
										.frame(height: 44)
										.contentShape(Rectangle())
										.onTapGesture {
											viewModel.apply(option)
											isNameFocused = false
										}
										.listSectionSpacing(0)
										.listRowInsets(
											EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
										)
								}
								.scrollContentBackground(.hidden)
								.padding(.horizontal, -16)
								.padding(.top, -30)
								.transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
								.animation(.easeInOut, value: viewModel.isOptionsShown)

							}
						}
					}
				}
				Spacer()
			}
			.padding(.horizontal, 16)
		}
	}
}

private struct PreviewWrapper: View {
	@State var showSheet: Bool = false
	var body: some View {
		Button("123") {
			showSheet.toggle()
		}
		.sheet(isPresented: $showSheet, content: {
			let viewModel: ProductEditViewModel = .init(list: ListItemModel(logo: .init(imageName: "paw", color: .appSystemRed), name: "123", products: []))
			ProductEditView(viewModel: viewModel)
		})
	}
}

#Preview {
	PreviewWrapper()
}
