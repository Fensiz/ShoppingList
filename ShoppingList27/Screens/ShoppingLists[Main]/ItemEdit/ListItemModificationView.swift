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
			VStack {
				ScrollView {
					VStack(spacing: 24) {
						VStack(spacing: 4) {
							AppTextField(
								text: $viewModel.listName,
								state: viewModel.isItemNameUnique ? .normal
								: .error("Это название уже используется, пожалуйста, измените его."),
								placeholder: "Введите название списка"
							)
						}
						AppColorPicker(
							selectedColor: $viewModel.selectedColor,
							title: viewModel.isNewItem ? "Выберите цвет" : "Цвет"
						)
						LogoGridPicker(
							selectedLogo: $viewModel.selectedLogo,
							selectedColor: viewModel.selectedColor
						)
					}
				}
				Spacer()
				AppButton(title: viewModel.isNewItem ? "Создать" : "Сохранить") {
					viewModel.save()
					coordinator.openShoppingListsScreen()
				}
				.disabled(viewModel.isSaveDisabled)
			}
			.padding(Constants.padding)
			.ignoresSafeArea(.keyboard)
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			BackButtonToolbar()
			TitleToolbar(title: "\(viewModel.isNewItem ? "Создать" : "Редактировать") список")
		}
	}
}

// #Preview {
//	NavigationStack {
//		let viewModel = ListItemModificationViewModel(
//			listItem: .mock,
//			onSave: {_ in},
//			checkExistance: {_ in false}
//		)
//		let coordinator = AppCoordinator()
//
//		ListItemModificationView(viewModel: viewModel)
//			.environment(coordinator)
//	}
// }
