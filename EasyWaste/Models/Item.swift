//
//  Item.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 2.01.25.
//

import Foundation
import SwiftData

enum ItemType: String, Codable {
    case food
    case garbage
    case furniture
    case all
}

enum ItemCategory: String, Codable {
    case meat
    case grains
    case vegetables
    case recyclable
    case compostable
    case household
}

@Model
class Item: Identifiable, Hashable, Codable {
    enum CodingKeys: CodingKey {
        case id, name, type, category, expirationDate, storageLocation, quantity, disposalInstructions, imageLink, fullImageLink
    }
    
    var id: Int
    var name: String
    var type: ItemType
    var category: ItemCategory
    var expirationDate: String?
    var storageLocation: String
    var quantity: String
    var disposalInstructions: String
    var fullImageLink: String?
    var imageLink: String
    
    init(id: Int, name: String, type: ItemType, category: ItemCategory, expirationDate: String?, storageLocation: String, quantity: String, disposalInstructions: String, fullImageLink: String?, imageLink: String) {
        self.id = id
        self.name = name
        self.type = type
        self.category = category
        self.expirationDate = expirationDate
        self.storageLocation = storageLocation
        self.quantity = quantity
        self.disposalInstructions = disposalInstructions
        self.imageLink = imageLink
        self.fullImageLink = fullImageLink
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(ItemType.self, forKey: .type)
        category = try container.decode(ItemCategory.self, forKey: .category)
        expirationDate = try container.decodeIfPresent(String.self, forKey: .expirationDate)
        storageLocation = try container.decode(String.self, forKey: .storageLocation)
        disposalInstructions = try container.decode(String.self, forKey: .disposalInstructions)
        quantity = try container.decode(String.self, forKey: .quantity)
        imageLink = try container.decode(String.self, forKey: .imageLink)
        fullImageLink = try container.decodeIfPresent(String.self, forKey: .fullImageLink)
    
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(category, forKey: .category)
        if let expirationDate { try container.encode(expirationDate, forKey: .expirationDate) }
        try container.encode(storageLocation, forKey: .storageLocation)
        try container.encode(disposalInstructions, forKey: .disposalInstructions)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(imageLink, forKey: .imageLink)
        if let fullImageLink { try container.encode(fullImageLink, forKey: .fullImageLink) }
    }
}
