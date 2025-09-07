//
//  MyListsView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 05.09.2025.
//

import SwiftUI

@Observable final class ShoppingListsViewModel {
	var list: [ListItem] = [
		.mock,
		.mock2,
		.mock3
	]
	private var itemForDeletion: ListItem?

	var isAlertPresented: Bool = false

	private func removeItem(_ item: ListItem?) {
		guard
			let item,
			let removable = list.firstIndex(of: item)
		else { return }
		list.remove(at: removable)
		print(list.count)
	}

	func confirmDeletion() {
		guard let itemForDeletion else { return }
		withAnimation {
			removeItem(itemForDeletion)
		}
		self.itemForDeletion = nil
	}
	func cancelDeletion() {
		self.itemForDeletion = nil
	}

	func showDeletionAlert(for item: ListItem) {
		itemForDeletion = item
		isAlertPresented = true
	}
	func removeItem(at index: Int) {
		list.remove(at: index)
	}
	func isItemExist(with name: String) -> Bool {
		list.contains(where: { $0.name == name })
	}
	func addItem(_ item: ListItem) {
		list.append(item)
	}
}

struct ShoppingListsView: View {
	@Environment(AppCoordinator.self) var coordinator: AppCoordinator
	@State var viewModel: ShoppingListsViewModel = .init()
	@Binding var appTheme: AppTheme

	var body: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			if viewModel.list.isEmpty {
				emptyListStub
			} else {
				List(viewModel.list) { item in
					ListsCellView(item: item) {
						coordinator.openShoppingListScreen(with: item)
					} editAction: {
						coordinator.openShoppingListEditScreen(
							with: item,
							action: viewModel.addItem,
							checkExistance: viewModel.isItemExist
						)
					} copyAction: {
						coordinator.openShoppingListCopyScreen(
							with: item,
							action: viewModel.addItem,
							checkExistance: viewModel.isItemExist
						)
					} deleteAction: {
						viewModel.showDeletionAlert(for: item)
					}
				}
				.padding(.top, -20)
				.listStyle(.insetGrouped)
				.scrollContentBackground(.hidden)
				.safeAreaInset(edge: .bottom) {
					AppButton(title: "Создать список") {
						coordinator.openShoppingListCreationScreen(
							action: viewModel.addItem,
							checkExistance: viewModel.isItemExist
						)
					}
					.padding(.bottom, 20)
					.padding(.horizontal, 16)
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Text("Мои списки")
					.font(.title1SemiBold)
			}
			ToolbarItem(placement: .navigationBarTrailing) {
				Menu {
					Picker(selection: $appTheme) {
						Text("Светлая").tag(AppTheme.light)
						Text("Темная").tag(AppTheme.dark)
						Text("Системная").tag(AppTheme.system)
					} label: {
						Label("Установить тему", image: .contrast)
					}
					.pickerStyle(.menu)
					Button {
						
					} label: {
						Label("Сортировать\nпо Алфавиту", systemImage: "arrow.up.arrow.down")
					}
				} label: {
					Image(.ellipsisDots)
						.foregroundColor(.appSystemIcon)
						.padding(10)
				}
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
	}

	@ViewBuilder var emptyListStub: some View {
		VStack(spacing: 0) {
			Spacer()
			VStack(spacing: 28) {
				Image("emptyListPlaceholder")
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
	
	var body: some View {
		NavigationStack {
			ShoppingListsView(appTheme: .constant(.dark))
				.environment(coordinator)
		}
	}
}

#Preview {
	PreviewWrapper()
}
