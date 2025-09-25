//
//  LogoGridPicker.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 04.09.2025.
//

import SwiftUI

struct LogoGridPicker: View {
	let logos: [String] = AppIcons.allCases.map(\.rawValue)

	@Binding var selectedLogo: String?
	let selectedColor: Color?

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("Выберите дизайн")
				.font(.calloutRegular)
				.padding(.leading, 4.5)
			LazyVGrid(
				columns: Array(repeating: GridItem(.flexible(minimum: 48, maximum: .infinity)), count: 6),
				alignment: .center,
				spacing: 12
			) {
				ForEach(logos, id: \.self) { logo in
					let isSelected = (selectedLogo == logo)
					let color = ((selectedColor != nil && isSelected) ? selectedColor! : .iconBackground)
					Button {
						if selectedColor != nil {
							selectedLogo = logo
						}
					} label: {
						Image(logo)
							.resizable()
							.scaledToFit()
							.frame(width: 24, height: 24)
							.padding(12)
							.frame(maxWidth: .infinity)
							.background(Circle().fill(color))
							.tint(isSelected ? .activeIcon : .inactiveIcon)
					}
					.frame(height: 48)
				}
			}
		}
		.padding(.vertical, 12)
		.padding(.horizontal, 7.5)

		.background {
			Color.elementBackground
		}
		.clipShape(RoundedRectangle(cornerRadius: 12))
		.frame(height: 225)
	}
}

struct LogoGridPicker_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			LogoGridPicker(selectedLogo: .constant("paw"), selectedColor: .red)
				.padding(16)
		}
	}
}
