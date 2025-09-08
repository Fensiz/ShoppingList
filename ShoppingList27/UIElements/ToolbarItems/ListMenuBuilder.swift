//
//  ListMenuBuilder.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 08.09.2025.
//

@resultBuilder
enum MenuBuilder {
	static func buildBlock(_ components: MenuElement...) -> [MenuElement] {
		components
	}
}
