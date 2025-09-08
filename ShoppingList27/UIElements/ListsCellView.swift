//
//  ListCellView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 03.09.2025.
//

import SwiftUI

struct ListsCellView: View {
	let item: ListItem
	let tapAction: () -> Void
	let editAction: () -> Void
	let copyAction: () -> Void
	let deleteAction: () -> Void

	var body: some View {
		Section {
			Button(action: tapAction) {
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
			}
			.swipeActions(edge: .trailing, allowsFullSwipe: false) {
				Button {
					deleteAction()
				} label: {
					Image(.trash)
				}
				.tint(.appSystemRed)

				Button {
					copyAction()
				} label: {
					Image(.duplicate)
				}
				.tint(.appSystemOrange)

				Button {
					editAction()
				} label: {
					Image(.modify)
				}
				.tint(.appSystemGrey)
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
		ListsCellView(item: .mock2) {print(1)}
			editAction: {}
			copyAction: {}
			deleteAction: {}
		ListsCellView(item: .mock2) {}
			editAction: {}
			copyAction: {}
			deleteAction: {}
			.border(Color.red)
	}
	.listStyle(.insetGrouped)
	.scrollContentBackground(.hidden)
	.background(Color.screenBackground)
}
