//
//  ItemRowView.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 2.01.25.
//

import SwiftUI

struct ItemRowView: View {
    
    var item: Item
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.imageLink)) { result in
                result.image?
                    .resizable()
                    .scaledToFill()
            }
                .frame(width: 50, height: 50)
                .cornerRadius(10)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
            
            Text(item.name)
                .lineLimit(2)
//                .lineBreakMode(.byTruncatingTail)
            Spacer()
            if let expirationDate = item.expirationDate {
                VStack {
                    Text("Expiration date")
                        .lineLimit(1)
                        .fixedSize()
                    Text(expirationDate)
                        .lineLimit(1)
                        .fixedSize()
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 20))
            }
        }
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        
    }
}

#Preview("1") {
    ItemRowView(item: ModelManager().items[0])
}

#Preview("2") {
    Group {
        ItemRowView(item: ModelManager().items[0])
        ItemRowView(item: ModelManager().items[1])
        ItemRowView(item: ModelManager().items[2])
        ItemRowView(item: ModelManager().items[3])
    }
}

