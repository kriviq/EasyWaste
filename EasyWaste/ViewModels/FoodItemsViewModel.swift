//
//  FoodItemsViewModel.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 13.01.25.
//

import Foundation

class FoodItemsViewModel: ViewModel {
    @Published var filter: ItemType = .all
    
    @Published var searchText: String = ""
    
    var items: [Item] {
        return modelManager.items
    }
    
    var filteredItems: [Item] {
        if !searchText.isEmpty {
            let lowercasedSearchText = searchText.lowercased()
            return modelManager.items.filter { item in
                item.name.lowercased().contains(lowercasedSearchText)
            }
        }
        
        return modelManager.items.filter { item in
            return filter == .all || item.type == filter
        }
    }
    
    private var modelManager: ModelManager {
        return model as! ModelManager
    }

}
