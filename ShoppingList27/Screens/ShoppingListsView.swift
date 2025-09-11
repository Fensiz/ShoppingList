//
//  MyListsView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 05.09.2025.
//

import SwiftUI
import SwiftData

@Model
final class ListItemModel {
	var logoImageName: String
	var logoColorHex: String

	@Attribute(.unique)
	var name: String
	@Relationship(deleteRule: .cascade)
	var products: [ProductListItemModel]
	@Transient
	var count: Int { products.map(\.isBought).count }
	@Transient
	var total: Int { products.count }
	@Transient
	var logo: ItemLogo {
		get {
			ItemLogo(
				imageName: logoImageName,
				color: Color(hex: logoColorHex)
			)
		}
		set {
			logoImageName = newValue.imageName
			logoColorHex = newValue.color.toHex()
		}
	}
	
	init(logo: ItemLogo, name: String, products: [ProductListItemModel]) {
		logoImageName = logo.imageName
		logoColorHex = logo.color.toHex()
		self.name = name
		self.products = products
	}
}

@Model
final class ProductListItemModel {
	@Attribute(.unique)
	var name: String
	@Relationship(deleteRule: .nullify, inverse: \ListItemModel.products)
	var list: ListItemModel
	var isBought: Bool = false
	var count: Int

	var unitRaw: String
	@Transient
	var unit: Unit {
		get { Unit(rawValue: unitRaw) ?? .piece }
		set { unitRaw = newValue.rawValue }
	}

	init(name: String, list: ListItemModel, count: Int, unit: Unit) {
		self.name = name
		self.list = list
		self.count = count
		self.unitRaw = unit.rawValue
	}
}

struct ListItem: Identifiable, Hashable {
	let logo: ItemLogo
	let name: String
	let count: Int
	let total: Int
	var id: String { name }
	init(logo: ItemLogo, name: String, count: Int, total: Int) {
		self.logo = logo
		self.name = name
		self.count = count
		self.total = total
	}

	static let mock: ListItem = .init(
		logo: .init(imageName: "paw", color: .blue),
		name: "Новый год",
		count: 10,
		total: 20
	)
	static let mock2: ListItem = .init(
		logo: .init(imageName: "paw", color: .indigo),
		name: "Новый гоqwdpiojqwdoiwj[qoipjoqwijdpoqwidopijqwpoidjqwpoijqwoas" +
		"pijqpwoijfopqiwjfopiqwfpoiqjopfijqpoifjqwopifqwopijqwpoijqwopijqwopi" +
		"jfqwopijfqwpoijfoqpiwд",
		count: 10,
		total: 20
	)
	static let mock3: ListItem = .init(
		logo: .init(imageName: "paw", color: .indigo),
		name: "Нqwdqwовqwdqwый гоqwdpiojqwdoiwj[qoipjoqwijdpoqwidopijqwpoidjqwpoijqwoas" +
		"pijqpwoijfopqiwjfopiqwfpoiqjopfijqpoifjqwopifqwopijqwpoijqwopijqwopi" +
		"jfqwopijfqwpoijfoqpiwд",
		count: 10,
		total: 20
	)
}

@Observable final class ShoppingListsViewModel {
	var list: [ListItemModel] = []
	private var itemForDeletion: ListItemModel?

	var isAlertPresented: Bool = false

	var context: ModelContext?

	init(context: ModelContext? = nil) {
		self.context = context
		fetchListItems()
	}

	func fetchListItems() {
		guard let context else { return }
		do {
			let descriptor = FetchDescriptor<ListItemModel>(sortBy: [SortDescriptor(\.name)])
			list = try context.fetch(descriptor)
		} catch {
			print("Ошибка загрузки списков: \(error)")
		}
	}
	private func removeItem(_ item: ListItemModel?) {
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

	func showDeletionAlert(for item: ListItemModel) {
		itemForDeletion = item
		isAlertPresented = true
	}
	func removeItem(at index: Int) {
		list.remove(at: index)
	}
	func isItemExist(with name: String) -> Bool {
		list.contains(where: { $0.name == name })
	}
	func addNewItem(_ item: ListItemModel) {
		print(1)
		guard let context else { return }
		print(2)
//		let model = ListItemModel(logo: item.logo, name: item.name, products: [])
		print(3)
		context.insert(item)
		saveContext()
		list.append(item)
	}
	private func saveContext() {
		do {
			try context?.save()
			print("ok")
		} catch {
			print("⚠️ Ошибка сохранения: \(error)")
		}
	}
}

struct ShoppingListsView: View {
	@Environment(AppCoordinator.self) var coordinator: AppCoordinator
	@State var viewModel: ShoppingListsViewModel
	@Environment(\.modelContext) private var context
	@Binding var appTheme: AppTheme

	var body: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			if viewModel.list.isEmpty {
				emptyListStub
			} else {
				List(viewModel.list, id: \.name) { item in
					ListsCellView(item: item)
						.swipeActions {
							AppSwipeAction.delete {
								viewModel.showDeletionAlert(for: item)
							}
//							AppSwipeAction.copy {
//								coordinator.openShoppingListCopyScreen(
//									with: item,
//									action: viewModel.addItem,
//									checkExistance: viewModel.isItemExist
//								)
//							}
//							AppSwipeAction.edit {
//								coordinator.openShoppingListEditScreen(
//									with: item,
//									action: viewModel.addItem,
//									checkExistance: viewModel.isItemExist
//								)
//							}
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
		.onAppear {
			viewModel.context = context
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			LargeTitleToolbar(title: "Мои списки")
			MenuToolbar {
				MenuElement.themeSelector($appTheme)
				MenuElement.sortByName({})
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
			ShoppingListsView(viewModel: .init(), appTheme: .constant(.dark))
				.environment(coordinator)
		}
	}
}

#Preview {
	PreviewWrapper()
}
