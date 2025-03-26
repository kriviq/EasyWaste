//
//  ItemDetailsView.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 1.01.25.
//

import SwiftUI

struct ItemDetailsView: View {
    @Environment(FoodItemsViewModel.self) var itemManager
    
    var itemIndex: Int {
        itemManager.filteredItems.firstIndex { currentItem in
            currentItem.id == item.id
        }!
    }
    
    var item: Item
    var body: some View {
        @Bindable var itemManager = itemManager
        
        //Name
        HStack {
            Image("food_category")
                .resizable()
                .frame(width: 32.0, height: 32.0)
            Spacer()
                .frame(width: 16.0)
            Text(item.name)
                .font(.largeTitle)
            Spacer()
            
        }
        .padding()
        
        Divider()
        
        //Image
        if let imageLink = item.fullImageLink {
            AsyncImage(url: URL(string: imageLink)) {result in
                result.image?
                    .resizable()
                    .scaledToFill()
                    .frame(height: 130)
                    .aspectRatio(contentMode: .fit)
            }
        }
        
        Divider()
        
        //Expiration
        HStack {
            Image("food_category")
                .resizable()
                .frame(width: 32.0, height: 32.0)
            Spacer()
                .frame(width: 16.0)
            if let expirationDate = item.expirationDate {
                Text("Expiration date: \(expirationDate)")
            }
           
            Spacer()
        }
        .padding()
        
        Divider()
        
        //Category
        HStack {
            Image("food_category")
                .resizable()
                .frame(width: 32.0, height: 32.0)
            Spacer()
                .frame(width: 16.0)
            Text("Category: \(item.category.rawValue.capitalized)")
            Spacer()
        }
        .padding()
        
        Button("Reset Expiration") {
            itemManager.items[itemIndex].expirationDate = "2021-01-01"
        }
        
        Spacer()
    }
}

#Preview {
    ItemDetailsView(item: ModelManager().items[0])
}
