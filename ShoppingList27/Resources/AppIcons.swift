//
//  AppIcons.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 04.09.2025.
//

import SwiftUI

enum AppIcons: String, CaseIterable {
	case snowflake
	case airplane
	case alert
	case balloon
	case bandage
	case barbell

	case bed
	case briefcase
	case wrench
	case business
	case calendar
	case gift

	case colorPalette
	case cart
	case car
	case fastFood
	case paw
	case gameController

	var image: Image {
		Image(self.rawValue)
	}
}
