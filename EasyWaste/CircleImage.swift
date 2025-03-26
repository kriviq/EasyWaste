//
//  CircleImage.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 31.12.24.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtle_rock")
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
        
    }
}

#Preview {
    CircleImage()
}
