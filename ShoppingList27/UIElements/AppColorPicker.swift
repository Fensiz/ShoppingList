//
//  AppColorPicker.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 04.09.2025.
//

import SwiftUI

struct AppColorPicker: View {
	let colors: [Color]
	@Binding var selectedColor: Color?
	private var title: String

	init(
		colors: [Color] = [.extraGreen, .extraPurple, .extraBlue, .extraRed, .extraYellow],
		selectedColor: Binding<Color?>,
		title: String
	) {
		self.colors = colors
		self._selectedColor = selectedColor
		self.title = title
	}
	var body: some View {
		GeometryReader { geometry in
			VStack(alignment: .leading, spacing: 12) {
				Text(title)
					.font(.calloutRegular)
					.padding(.leading, 12)
				let width = CGFloat(colors.count * 40 + (colors.count + 1) * 20)
				let padding = width > geometry.size.width ? 16 : (geometry.size.width - width) / 2
				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 20) {
						Spacer(minLength: 0)
						ForEach(colors, id: \.self) { color in
							Button {
								selectedColor = color
							} label: {
								color
									.clipShape(Circle())
									.frame(width: 40, height: 40)
									.overlay {
										color == selectedColor ? Circle()
											.inset(by: -2)
											.strokeBorder(Color.turtoise, lineWidth: 2)
											.frame(width: 48, height: 48)
										: nil
									}
							}
						}
						.frame(maxWidth: width)
						Spacer(minLength: 0)
					}
					.padding(.horizontal, padding)
					.frame(height: 54)
				}
			}
			.padding(.vertical, 12)
		}
		.background {
			Color.elementBackground
		}
		.clipShape(RoundedRectangle(cornerRadius: 12))
		.frame(height: 105)
	}
}

#Preview {
	ZStack {
		Color.screenBackground.ignoresSafeArea()
		VStack {
			AppColorPicker(
				colors: [],
				selectedColor: .constant(.black),
				title: "123"
			)
			AppColorPicker(
				colors: [.black, .blue, .brown],
				selectedColor: .constant(.black),
				title: "123"
			)
			AppColorPicker(
				colors: [.black, .blue, .brown, .red, .yellow, .teal, .appText],
				selectedColor: .constant(nil),
				title: "123"
			)
			AppColorPicker(
				colors: [.black, .blue, .brown, .red, .yellow, .teal, .red, .appText],
				selectedColor: .constant(.black),
				title: "123"
			)
			AppColorPicker(
				selectedColor: .constant(.black),
				title: "123"
			)
		}
		.padding(16)
	}
}
