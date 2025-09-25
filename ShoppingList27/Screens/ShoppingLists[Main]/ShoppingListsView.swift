//
//  MyListsView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 05.09.2025.
//

import SwiftUI

struct ShoppingListsView: View {
	@Environment(AppCoordinator.self) private var coordinator: AppCoordinator
	@State var viewModel: ShoppingListsViewModel
	@Binding var appTheme: AppTheme

	var body: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			if viewModel.list.isEmpty {
				emptyListStub
			} else {
				List($viewModel.list, id: \.name) { $item in
					ListsCellView(item: $item)
						.swipeActions {
							AppSwipeAction.delete {
								viewModel.showDeletionAlert(for: item)
							}
							AppSwipeAction.copy {
								coordinator.openShoppingListCopyScreen(
									with: item,
									action: viewModel.addNewItem,
									checkExistance: viewModel.isItemExist
								)
							}
							AppSwipeAction.edit {
								coordinator.openShoppingListEditScreen(
									with: item,
									action: viewModel.updateItem,
									checkExistance: viewModel.isItemExist
								)
							}
						}
						.onTapGesture {
							coordinator.openShoppingListScreen(with: item)
						}
				}
				.padding(.top, -20)
				.listStyle(.insetGrouped)
				.scrollContentBackground(.hidden)
				.safeAreaInset(edge: .bottom) {
					Color.clear
						.frame(height: 64)
				}
			}
			VStack {
				Spacer()
				AppButton(title: "Создать список") {
					coordinator.openShoppingListCreationScreen(
						action: viewModel.addNewItem,
						checkExistance: viewModel.isItemExist
					)
				}
				.padding(.bottom, 20)
				.padding(.horizontal, 16)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			LargeTitleToolbar(title: "Мои списки")
			MenuToolbar {
				MenuElement.themeSelector($appTheme)
				MenuElement.sortByName(viewModel.toggleSortState, viewModel.sortState)
			}
		}
		.alert("Удаление списка", isPresented: $viewModel.isAlertPresented) {
			Button("Удалить", role: .destructive) {
				viewModel.confirmDeletion()
			}
			Button("Отмена", role: .cancel) {
				viewModel.cancelDeletion()
			}
		} message: {
			Text("Вы действительно хотите удалить список?")
		}
		.onAppear {
			coordinator.onMainScreenAppear = { [weak viewModel] in
				viewModel?.updateList()
			}
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
	let dataSource = MockListItemDataSource()

	var body: some View {
		NavigationStack(path: $coordinator.navigationPath) {
			let viewModel = ShoppingListsViewModel(dataSource: dataSource)
			ShoppingListsView(viewModel: viewModel, appTheme: .constant(.dark))
				.navigationDestination(for: AppCoordinator.Screen.self) { screen in
					switch screen {
					default:
						EmptyView()
					}
				}
		}
		.environment(coordinator)
	}
}

#Preview {
	PreviewWrapper()
}
