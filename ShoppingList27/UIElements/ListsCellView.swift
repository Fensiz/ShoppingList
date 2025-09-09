//
//  ListCellView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 03.09.2025.
//

import SwiftUI

struct ListsCellView: View {
	let item: ListItem

	var body: some View {
		Section {
			HStack(spacing: 12) {
				ZStack {
					item.logo.color
						.clipShape(Circle())
					Image(item.logo.imageName)
						.foregroundStyle(Color.activeIcon)
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
				.foregroundStyle(Color.appText)
			}
			.padding(Constants.padding)
			.background(Color.elementBackground)
			.clipShape(
				.rect(
					topLeadingRadius: 12,
					bottomLeadingRadius: 12,
					bottomTrailingRadius: 0,
					topTrailingRadius: 0
				)
			)
		}
		.listSectionSpacing(12)
		.listRowInsets(
			EdgeInsets()
		)
		.listRowSeparator(.hidden)
		.listRowBackground(Color.clear)
	}
}

#Preview {
	List {
		ListsCellView(item: .mock2)
		ListsCellView(item: .mock2)
			.border(Color.red)
	}
	.listStyle(.insetGrouped)
	.scrollContentBackground(.hidden)
	.background(Color.screenBackground)
}
