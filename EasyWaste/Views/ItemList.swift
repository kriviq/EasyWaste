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
        List(itemManager.filteredItems) { item in
            NavigationLink {
                ItemDetailsView(item: item)
                    .environment(itemManager)
            } label: {
                ItemRowView(item: item)
            }
        }
        .clipShape(Rectangle())
    }
}

#Preview {
    ItemList()
        .environment(FoodItemsViewModel(with: ModelManager()))
}
