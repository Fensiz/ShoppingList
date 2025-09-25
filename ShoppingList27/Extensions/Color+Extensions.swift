//
//  Color+.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 10.09.2025.
//

import SwiftUI

extension Color {
	init(hex: String) {
		let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var intValue: UInt64 = 0
		Scanner(string: hexString).scanHexInt64(&intValue)

		let alpha, red, green, blue: UInt64
		switch hexString.count {
		case 6: // RGB (24-bit)
			(alpha, red, green, blue) = (255, (intValue >> 16) & 0xFF, (intValue >> 8) & 0xFF, intValue & 0xFF)
		case 8: // ARGB (32-bit)
			(alpha, red, green, blue) = ((intValue >> 24) & 0xFF, (intValue >> 16) & 0xFF, (intValue >> 8) & 0xFF, intValue & 0xFF)
		default:
			(alpha, red, green, blue) = (255, 0, 0, 0)
		}

		self.init(
			.sRGB,
			red: Double(red) / 255,
			green: Double(green) / 255,
			blue: Double(blue) / 255,
			opacity: Double(alpha) / 255
		)
	}

	func toHex(includeAlpha: Bool = false) -> String {
		let uiColor = UIColor(self)
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
		uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		if includeAlpha {
			return String(
				format: "%02X%02X%02X%02X",
				Int(alpha * 255), Int(red * 255), Int(green * 255), Int(blue * 255)
			)
		} else {
			return String(
				format: "%02X%02X%02X",
				Int(red * 255), Int(green * 255), Int(blue * 255)
			)
		}
	}
}
