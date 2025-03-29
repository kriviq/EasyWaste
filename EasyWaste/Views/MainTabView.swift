//
//  MainTabView.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 26.03.25.
//


import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var foodItemsViewModel: FoodItemsViewModel
    var body: some View {
        TabView {
            // Food Tab (Current View Hierarchy)
            NavigationStack {
                ContentView()
                    .environment(foodItemsViewModel)
            }
            .tabItem {
                Label("Food", systemImage: "fork.knife")
            }
            
            // Recyclable Tab
            NavigationStack {
                Text("Recyclable Items")
            }
            .tabItem {
                Label("Recyclable", systemImage: "arrow.triangle.2.circlepath")
            }
            
            // Furniture Tab
            NavigationStack {
                Text("Furniture Items")
            }
            .tabItem {
                Label("Furniture", systemImage: "chair")
            }
            
            // Medicine Tab
            NavigationStack {
                Text("Medicine Items")
            }
            .tabItem {
                Label("Medicine", systemImage: "pills")
            }
            
            // Scan Tab
            NavigationStack {
                ScanView()
//                CameraContentView()
            }
            .tabItem {
                Label("Scan", systemImage: "camera")
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(FoodItemsViewModel(with: ModelManager()))
}
