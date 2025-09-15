//
//  ListView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 06.09.2025.
//

import SwiftUI

struct ShoppingListView: View {
	@Environment(\.presentationMode) private var presentationMode
	@Environment(AppCoordinator.self) var coordinator: AppCoordinator
	@State var viewModel: ShoppingListViewModel

	var body: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			if viewModel.filteredProducts.isEmpty {
				emptyListStub
			} else {
				List(viewModel.filteredProducts) { $item in
					ProductRow(item: $item)
						.swipeActions {
							AppSwipeAction.delete {
								viewModel.showDeletionAlert(for: item)
							}
							AppSwipeAction.edit {
								viewModel.openEditScreen(for: item)
							}
						}
						.listSectionSeparator(viewModel.isFirstItem(item) ? .hidden : .visible, edges: .top)
				}
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
				.safeAreaInset(edge: .bottom) {
					Color.clear
						.frame(height: 64)
				}
			}
			VStack {
				Spacer()
				AppButton(title: "Добавить товар") {
					viewModel.openCreationScreen()
				}
				.padding(.bottom, 20)
				.padding(.horizontal, 16)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			BackButtonToolbar()
			TitleToolbar(title: viewModel.list.name)
			MenuToolbar {
				MenuElement.sortByName(viewModel.toggleSortState, viewModel.sortState)
				MenuElement.share(viewModel.share)
				MenuElement.uncheckAll(viewModel.uncheckAll)
				MenuElement.deleteBought(viewModel.showDeletionAlertForAllBoughtDeletion)
			}
		}
		.searchable(text: $viewModel.searchText, prompt: "Поиск")
		.alert(viewModel.alertText.title, isPresented: $viewModel.isAlertPresented) {
			Button("Удалить", role: .destructive) {
				viewModel.confirmProductDeletion()
			}
			Button("Отмена", role: .cancel) {
				viewModel.cancelProductDeletion()
			}
		} message: {
			Text("Вы действительно хотите удалить список?")
		}
		.sheet(isPresented: $viewModel.isEditScreenPresented) {
			viewModel.sheetCloseCompetion()
		} content: {
			let viewModel = ProductEditViewModel(
				item: viewModel.productForEdit,
				list: viewModel.list,
				saveAction: viewModel.save,
				cancelAction: viewModel.closeEditScreen,
				isExistCheckAction: viewModel.checkExistance,
				fetchAction: viewModel.fetchOptions
			)
			ProductEditView(viewModel: viewModel)
		}
	}

	@ViewBuilder var emptyListStub: some View {
		VStack(spacing: 0) {
			Spacer()
			VStack(spacing: 28) {
				Image(.emptyListPlaceholder)
				VStack(spacing: 4) {
					Text("Давайте спланируем покупки!")
						.font(.title3Semibold)
					Text("Создайте свой первый список")
						.font(.appBody)
				}
				.foregroundStyle(.appText)
				.multilineTextAlignment(.center)
			}
			Spacer()
		}
		.padding(.bottom, 84)
		.padding(.horizontal, 16)
	}
}

private struct PreviewWrapper: View {
	@State private var coordinator = AppCoordinator()
	let list: ListItemModel

	init() {
		let list = ListItemModel(logo: .init(imageName: "paw", color: .appSystemRed), name: "123", products: [])
		list.products = [.init(name: "asd", list: list, count: 2, unit: .gram)]
		self.list = list
	}

	var body: some View {
		NavigationStack {
			let dataSource = ProductItemDataSource(context: nil)
			let viewModel = ShoppingListViewModel(list: list, dataSource: dataSource)
			ShoppingListView(viewModel: viewModel)
				.environment(coordinator)
		}
	}
}

#Preview {
	PreviewWrapper()
}
