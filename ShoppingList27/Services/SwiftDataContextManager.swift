//
//  SwiftDataContextManager.swift
//  ShoppingList27
//
//  Created by Симонов Иван Дмитриевич on 10.09.2025.
//


//import Foundation
//import SwiftData
//
//class SwiftDataContextManager{
//	// Singleton
//	static let shared = SwiftDataContextManager()
//
//	var container: ModelContainer?
//	var context : ModelContext?
//
//	private init() {
//		do {
//			container = try ModelContainer(for: Contact.self)
//			if let container {
//				context = ModelContext(container)
//			}
//		} catch {
//			debugPrint("Error initializing database container:", error)
//		}
//	}
//}
