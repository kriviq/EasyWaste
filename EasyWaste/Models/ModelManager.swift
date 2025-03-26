//
//  ModelManager.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 2.01.25.
//

import Foundation
import SwiftData

class ModelManager: Model {
    var items: [Item] {
        if _items == nil {
            _items = load("items_example.json")
        }
        
        return _items!
        
    }
    
    private var _items: [Item]?
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
