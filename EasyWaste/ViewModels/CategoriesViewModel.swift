//
//  CategoriesViewModel.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 13.01.25.
//

import Foundation


class CategoriesViewModel: ViewModel {
    
    @Published var filter: ItemType = .all
    
    var categories: [String: [Item]] {
        Dictionary(
            grouping: items,
            by: { $0.type.rawValue }
        )
    }
    
    var items: [Item] {
        return modelManager.items
    }
    
    private var modelManager: ModelManager {
        return model as! ModelManager
    }

}
