//
//  EasyWasteApp.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 16.08.24.
//

import SwiftUI
import SwiftData

@main
struct EasyWasteApp: App {
    @State private var foodItemsViewModel: FoodItemsViewModel = FoodItemsViewModel(with: ModelManager())
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(foodItemsViewModel)
        }
    }
}
