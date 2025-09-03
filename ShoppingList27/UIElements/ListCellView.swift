//
//  ListCellView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 03.09.2025.
//

import SwiftUI

struct ListCellView: View {
	let item: ListItem

	var body: some View {
		HStack(spacing: 12) {
			ZStack {
				item.logo.color
					.clipShape(Circle())
				Image(item.logo.imageName)
			}
			.frame(width: Constants.logoSize, height: Constants.logoSize)
			.padding(.vertical, Constants.padding / 8)

			HStack(spacing: 0) {
				Text(item.name)
					.font(.title3Semibold)
					.lineLimit(1)
				Spacer(minLength: Constants.padding / 2)
				HStack(spacing: 0) {
					Text("\(item.count)/")
						.font(Font.appBody)
					Text("\(item.total)")
						.font(Font.appHeadline)
				}
			}
		}
		.padding(Constants.padding)
		.background(Color.white)
		.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
		.listRowInsets(
			EdgeInsets(
				top: Constants.spaceBetweenRows / 2,
				leading: Constants.rowHorizontalPadding,
				bottom: Constants.spaceBetweenRows / 2,
				trailing: Constants.rowHorizontalPadding,
			)
		)
		.listRowSeparator(.hidden)
		.listRowBackground(Color.clear)
	}
}

#Preview {
	List {
		ListCellView(item: .mock2)
		ListCellView(item: .mock2)
			.border(Color.red)
	}
	.listStyle(.plain)
	.background(Color.gray) // заменить на цвет из asset
}
