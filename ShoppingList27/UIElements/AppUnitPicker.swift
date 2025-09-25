//
//  AppUnitPicker.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 08.09.2025.
//

import SwiftUI

struct AppUnitPicker: View {
	@Binding var selectedUnit: Unit
	var body: some View {
		HStack {
			Text("Ед.изм.:")
				.foregroundStyle(.greyHint)
			Spacer()
			Menu {
				Picker("", selection: $selectedUnit) {
					ForEach(Unit.allCases, id: \.self) { unit in
						Text(unit.rawValue).tag(unit)
					}
				}
			} label: {
				HStack {
					Text(selectedUnit.rawValue)
					Image(.arrows)
				}
				.foregroundStyle(.turtoise)
			}
		}
		.font(.appBody)
		.padding(.horizontal, 16)
		.frame(height: 54)
		.background(.elementBackground)
		.clipShape(RoundedRectangle(cornerRadius: 12))
	}
}

#Preview {
	ZStack {
		Color.screenBackground.ignoresSafeArea()
		AppUnitPicker(selectedUnit: .constant(.gram))
	}
}
