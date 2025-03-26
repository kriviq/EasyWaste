//
//  CategoryRow.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 17.01.25.
//

import SwiftUI


struct CategoryRow: View {
    var categoryName: String
    var items: [Item]
    var body: some View {
        Text(categoryName)
            .font(.headline)
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(items, id: \.self) { item in
                    VStack {
                        Text(item.name)
                            .padding(.leading)
                            .padding(.trailing)
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                    .frame(width: 120, height: 80)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(.green, lineWidth: 3)
                    })
                    .shadow(radius: 10)
//                    .background(.green)
                }
            }
        }
    }
}


#Preview {
    let viewModel = CategoriesViewModel(with: ModelManager())
    CategoryRow(categoryName: "Food", items: viewModel.categories[ItemType.food.rawValue]!)
}
