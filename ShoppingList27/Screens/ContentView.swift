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
            Text("Hello, Factory!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
