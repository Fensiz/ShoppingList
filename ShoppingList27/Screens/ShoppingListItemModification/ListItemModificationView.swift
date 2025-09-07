//
//  ListItemModificationView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 04.09.2025.
//

import SwiftUI

struct ListItemModificationView: View {
	@Environment(\.presentationMode) private var presentationMode
	@Environment(AppCoordinator.self) var coordinator
	@State var viewModel: ListItemModificationViewModel

	init(viewModel: ListItemModificationViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			VStack(spacing: 24) {
				VStack(spacing: 4) {
					AppTextField(text: $viewModel.listName)
					if !viewModel.isItemNameUnique {
						Text("Это название уже используется, пожалуйста, измените его.")
							.foregroundStyle(.appSystemRed)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.horizontal, 8)
					}
				}
				AppColorPicker(
					selectedColor: $viewModel.selectedColor,
					title: viewModel.isNewItem ? "Выберите цвет" : "Цвет"
				)
				LogoGridPicker(
					selectedLogo: $viewModel.selectedLogo,
					selectedColor: viewModel.selectedColor
				)
				Spacer()
				AppButton(title: viewModel.isNewItem ? "Создать" : "Сохранить") {
					viewModel.save()
					coordinator.openShoppingListsScreen()
				}
				.disabled(viewModel.isSaveDisabled)
			}
			.padding(16)
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					presentationMode.wrappedValue.dismiss()
				} label: {
					Image("chevron.left")
						.foregroundColor(.appSystemIcon)
				}
			}

			ToolbarItem(placement: .principal) {
				HStack {
					Text("\(viewModel.isNewItem ? "Создать" : "Редактировать") список")
						.font(.appHeadline)
					Spacer()
				}
			}
		}
	}
}

#Preview {
	NavigationStack {
		let viewModel = ListItemModificationViewModel(
			listItem: .mock,
			onSave: {_ in},
			checkExistance: {_ in false}
		)
		let coordinator = AppCoordinator()

		ListItemModificationView(viewModel: viewModel)
			.environment(coordinator)
	}
}
