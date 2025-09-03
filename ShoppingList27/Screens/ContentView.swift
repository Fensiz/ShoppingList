//
//  ContentView.swift
//  ShoppingList27
//
//  Created by Nikita Tsomuk on 01.09.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Image(systemName: "apple.logo")
                .imageScale(.large)
                .foregroundStyle(.tint)
            VStack {
                Text("Абвгде")
                    .font(.custom("Rubik-Medium", size: 60))
                Text("Абвгде")
                    .font(.custom("Rubik-Regular", size: 60))
                Text("Абвгде")
                    .font(.system(size: 60, weight: .medium))
            }

        }
        .padding()
        .onAppear {
            for family in UIFont.familyNames {
                print(family)
                for name in UIFont.fontNames(forFamilyName: family) {
                    print("  \(name)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
