//
//  ItemList.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 2.01.25.
//

import SwiftUI

struct ItemList: View {
    @Environment(FoodItemsViewModel.self) var itemManager
    var body: some View {
        NavigationSplitView {
            List(itemManager.filteredItems) { item in
                NavigationLink {
                    ItemDetailsView(item: item)
                        .environment(itemManager)
                } label: {
                    ItemRowView(item: item)
                }
            }
//            .padding(EdgeInsets(top: -10, leading: -20, bottom: -10, trailing: -20))
            .clipShape(Rectangle())
//            .navigationTitle("Items")
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    ItemList()
        .environment(FoodItemsViewModel(with: ModelManager()))
}
