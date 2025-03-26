//
//  CategoryHome.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 13.01.25.
//


import SwiftUI

struct CategoryHome: View {
    @Environment(CategoriesViewModel.self) var categoriesViewModel
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(categoriesViewModel.categories.keys.sorted(), id: \.self) { key in
                    Text(key.capitalized)
                }
            }
        } detail: {
            Text("Select a Landmark")
        }
    }
}

#Preview {
    CategoryHome()
        .environment(CategoriesViewModel(with: ModelManager()))
}
