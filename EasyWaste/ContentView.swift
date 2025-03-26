//
//  ContentView.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 16.08.24.
//

import SwiftUI
import SwiftData

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))
    }
}

struct ContentView: View {
    @Environment(FoodItemsViewModel.self) var itemManager
    
    @State private var isSearchActive = false
    
    @FocusState var focused: Bool?
    
    var body: some View {
        @Bindable var itemManager = itemManager
        HStack {
            Spacer()
                .frame(width: isSearchActive ? 20.0 : .none)
            HStack {
                if isSearchActive {
                    TextField("Search", text: $itemManager.searchText)
                        .focused($focused, equals: true)
                        .padding()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                self.focused = true
                            }
                        }
                }
                Button {
                    if isSearchActive {
                        itemManager.searchText = ""
                    }
                    withAnimation(.spring()) {
                        isSearchActive.toggle()
                    }
                } label: {
                    if isSearchActive {
                        Text("Cancel")
                    } else {
                        Image(systemName: "magnifyingglass")
                    }
                    
                }
                .frame(width: isSearchActive ? .none : 30)
                .padding()
                .tint(.green)
            }
            .cornerRadius(30)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.green, lineWidth: 5)
            )
            .animation(.easeInOut, value: isSearchActive)
            
            Spacer()
                .frame(width: 20)
        }
        
        ItemList()
            .environment(itemManager)
        Button("Filter\(itemManager.filter == .food ? " (Food)" : "")") {
            if itemManager.filter == .food {
                 itemManager.filter = .all
            } else {
                itemManager.filter = .food
            }
        }
    }
}


#Preview {
    ContentView()
        .environment(FoodItemsViewModel(with: ModelManager()))
}
