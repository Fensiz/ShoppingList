//
//  ListView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 06.09.2025.
//

import SwiftUI

@Observable final class ShoppingListViewModel {
	let listName: String
	var products: [Product] = []
	var searchText: String = ""
	var filteredProducts: [Product] {
		if searchText.isEmpty { return products }
		return products.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
	}

	var alertText: (title: String, message: String) = ("", "")

	var isAlertPresented: Bool = false
	private var productForDeletion: Product?

	init(listName: String, products: [Product]) {
		self.listName = listName
		self.products = products
	}

	func isFirstItem(_ item: Product) -> Bool {
		guard !products.isEmpty else { return false }
		return products.first == item
	}

	func toggleCheck(for item: Product) {
		guard let index = products.firstIndex(of: item) else { return }
		products[index].isBought.toggle()
	}

	func confirmProductDeletion() {
		if
			let productForDeletion,
			let index = products.firstIndex(of: productForDeletion) {
			products.remove(at: index)
			self.productForDeletion = nil
		}
		isAlertPresented = false
		alertText = ("", "")
	}
	func cancelProductDeletion() {
		self.productForDeletion = nil
		isAlertPresented = false
		alertText = ("", "")
	}

	func updateProduct(_ product: Product) {
		guard let index = products.firstIndex(of: product) else { return }
		products[index] = product
	}

	func showDeletionAlertForAllBoughtDeletion() {
		alertText = (
			title: "Удаление купленных товаров",
			message: "Вы действительно хотите удалить все купленные товары?"
		)
		isAlertPresented = true
	}

	func showDeletionAlert(for item: Product) {
		alertText = (
			title: "Удаление товара",
			message: "Вы действительно хотите удалить товар?"
		)
		productForDeletion = item
		isAlertPresented = true
	}

	func deleteAllBought() {
		products.removeAll(where: { $0.isBought })
		isAlertPresented = false
		alertText = ("", "")
	}

	func uncheckAll() {
		products.indices.forEach { products[$0].isBought = false }
	}

	func sortProductsByName() {
		products.sort { $0.name < $1.name }
	}
}

struct ShoppingListView: View {
	@Environment(\.presentationMode) private var presentationMode
	@Environment(AppCoordinator.self) var coordinator: AppCoordinator
	@State var viewModel: ShoppingListViewModel = .init(listName: "123", products: [
		.init(name: "qwe6", count: 5, unit: .piece, isBought: true),
		.init(name: "qwe2", count: 5, unit: .piece, isBought: true),
		.init(name: "qwe3", count: 5, unit: .piece, isBought: true),
	])

	var body: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			if viewModel.products.isEmpty {
				emptyListStub
			} else {
				List(viewModel.filteredProducts) { item in
					if let index = viewModel.products.firstIndex(of: item) {
						ProductRow(item: $viewModel.products[index]) { item in
							_ = item
						} deleteAction: { item in
							viewModel.showDeletionAlert(for: item)
						}
						.listSectionSeparator(.hidden, edges: .top)
					}
				}
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
				.safeAreaInset(edge: .bottom) {
					AppButton(title: "Добавить товар") {
//						coordinatorЭ
					}
					.padding(.bottom, 20)
					.padding(.horizontal, 16)
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			BackButtonToolbar()
			TitleToolbar(title: viewModel.listName)
			MenuToolbar {
				MenuElement.sortByName(viewModel.sortProductsByName)
				MenuElement.share({})
				MenuElement.uncheckAll(viewModel.uncheckAll)
				MenuElement.deleteBought(viewModel.deleteAllBought)
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

	var body: some View {
		NavigationStack {
			ShoppingListView()
				.environment(coordinator)
		}
	}
}

#Preview {
	PreviewWrapper()
}

struct ProductRow: View {
	@Binding var item: Product
	let editAction: (Product) -> Void
	let deleteAction: (Product) -> Void

	var body: some View {
		HStack(spacing: 8) {
			Button {
				item.isBought.toggle()
			} label: {
				Image(item.isBought ? .checkboxMarked : .checkboxEmpty)
					.frame(width: 44, height: 44)
			}
			Text(item.name)
				.foregroundStyle(item.isBought ? .appCheckedText : .appText)
			Spacer()
			Text("\(item.count) \(item.unit.rawValue)")
				.font(.subheadline)
				.foregroundColor(.secondary)
		}
		.font(.appBody)
		.padding(.horizontal, 16)
		.frame(height: 52)
		.listRowInsets(.init())
		.background(.screenBackground)
		.swipeActions(edge: .trailing, allowsFullSwipe: false) {
			Button {
				deleteAction(item)
			} label: {
				Image(.trash)
			}
			.tint(.appSystemRed)
			Button {
				editAction(item)
			} label: {
				Image(.modify)
			}
			.tint(.appSystemGrey)
		}
	}
}

struct ProductItemModificationView: View {
	@State var name: String = ""
	@State var unit: Unit = .piece

	var body: some View {
		VStack {
			AppTextField(text: $name)
			HStack {
				AppTextField(text: .constant("1"), state: .normal)
				AppUnitPicker(selectedUnit: $unit)
			}
		}
	}
}

#Preview {
	ProductItemModificationView()
}


// MARK: - Кастомная кнопка для возврата
struct BackButton: View {
	@Environment(\.presentationMode) private var presentationMode
	var imageName: String = "chevron.left"
	var color: Color = .appSystemIcon

	var body: some View {
		Button {
			presentationMode.wrappedValue.dismiss()
		} label: {
			Image(imageName)
				.foregroundColor(color)
		}
	}
}

// MARK: - Тулбар с кнопкой назад
struct BackButtonToolbar: ToolbarContent {
	var body: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			BackButton()
		}
	}
}
