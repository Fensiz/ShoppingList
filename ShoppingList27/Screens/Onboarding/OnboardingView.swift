//
//  OnboardingView.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 05.09.2025.
//

import SwiftUI

struct OnboardingView: View {
	let action: () -> Void

	var body: some View {
		ZStack {
			Color.screenBackground.ignoresSafeArea()
			VStack {
				Spacer()
				VStack(spacing: 48) {
					Text("Добро пожаловать!")
						.font(.largeTitleRegular)
						.foregroundStyle(.appText)
					Image("onboardingLogo")
					VStack(spacing: 12) {
						Text("Никогда не забывайте,\nчто нужно купить")
							.font(.title2Semibold)
							.foregroundStyle(.appText)
							.multilineTextAlignment(.center)
						Text("Создавайте списки\nи не переживайте о покупках")
							.font(.appBody)
							.foregroundStyle(.appText)
							.multilineTextAlignment(.center)
					}
				}
				Spacer()
				AppButton(title: "Начать") {
					action()
				}
				.padding(.vertical, 20)
			}
			.padding(.horizontal, 16)
		}
	}
}

#Preview {
	OnboardingView {}
}
