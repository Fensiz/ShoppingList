//
//  BackButtonToolbar.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 09.09.2025.
//

import SwiftUI

struct BackButtonToolbar: ToolbarContent {
	var body: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			BackButton()
		}
	}
}

private struct BackButton: View {
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
