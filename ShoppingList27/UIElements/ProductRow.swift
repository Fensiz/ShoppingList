//
//  ProductRow.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 13.09.2025.
//

import SwiftUI

struct ProductRow: View {
	@Binding var item: ProductItemModel

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
	}
}

#Preview {
	ProductRow(
		item: .constant(ProductItemModel(
			name: "asd",
			list: ListItemModel(logo: .init(imageName: "paw", color: .activeIcon), name: "qwe", products: []),
			count: 2,
			unit: .piece
		))
	)
}
