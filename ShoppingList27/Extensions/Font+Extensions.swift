//
//  AppFonts.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 02.09.2025.
//

import SwiftUI

extension Font {
    enum RubikWeight: String {
        case light = "Rubic-Light"
        case regular = "Rubic-Regular"
        case medium = "Rubic-Medium"
        case semibold = "Rubic-SemiBold"
    }

    enum RubikSize: CGFloat {
        case largeTitle = 34
        case title1 = 28
        case title2 = 22
        case title3 = 20
        case callout = 16
        case subheading = 15
        case footnote = 13
        case caption1 = 12
        case caption2 = 11
    }

    static func rubik(_ weight: RubikWeight, size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }

    static func rubik(_ weight: RubikWeight, size: RubikSize) -> Font {
        Font.custom(weight.rawValue, size: size.rawValue)
    }

    static let headline: Font = .rubik(.medium, size: 17)
    static let body: Font = .rubik(.regular, size: 17)
    static let largeTitleRegular: Font = .rubik(.regular, size: .largeTitle)
    static let largeTitleSemibold: Font = .rubik(.semibold, size: .largeTitle)
    static let title1Regular: Font = .rubik(.regular, size: .title1)
    static let title1SemiBold: Font = .rubik(.semibold, size: .title1)
    static let title2Regular: Font = .rubik(.regular, size: .title2)
    static let title2Semibold: Font = .rubik(.semibold, size: .title2)
    static let title3Regular: Font = .rubik(.regular, size: .title3)
    static let title3Semibold: Font = .rubik(.medium, size: .title3) //! не совпадает название с типом шрифта
    static let calloutRegular: Font = .rubik(.regular, size: .callout)
    static let calloutSemibold: Font = .rubik(.medium, size: .callout) //! не совпадает название с типом шрифта
    static let subheadingRegular: Font = .rubik(.regular, size: .subheading)
    static let subheadingMedium: Font = .rubik(.medium, size: .subheading)
    static let footnoteRegular: Font = .rubik(.regular, size: .footnote)
    static let footnoteSemibold: Font = .rubik(.medium, size: .footnote)
    static let caption1Light: Font = .rubik(.light, size: .caption1)
    static let caption1Medium: Font = .rubik(.regular, size: .caption1)
    static let caption2Light: Font = .rubik(.light, size: .caption2)
    static let caption2Semibold: Font = .rubik(.regular, size: .caption2)

    //M3
    static let m3HeadlineLarge: Font = .rubik(.regular, size: 32)
    static let m3HeadlineMedium: Font = .rubik(.medium, size: 28)
    static let m3HeadlineSmall: Font = .rubik(.regular, size: 24)
    static let m3TitleLarge: Font = .rubik(.regular, size: 22)
    static let m3TitleMedium: Font = .rubik(.medium, size: 16)
    static let m3TitleSmall: Font = .rubik(.regular, size: 14)
    static let m3LabelLarge: Font = .rubik(.medium, size: 14)
    static let m3LabelMediumProminent: Font = .rubik(.semibold, size: 12)
    static let m3LabelMedium: Font = .rubik(.medium, size: 12)
    static let m3LabelSmall: Font = .rubik(.medium, size: 11)
    static let m3BodyLarge: Font = .rubik(.regular, size: 16)
    static let m3BodyMedium: Font = .rubik(.regular, size: 14)
    static let m3BodySmall: Font = .rubik(.regular, size: 12)
}
