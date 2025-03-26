//
//  ViewModel.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 13.01.25.
//

import Foundation
import SwiftUI

protocol Model {
    
}

class ViewModel: ObservableObject, Observable {
    
    var model: Model {
        didSet {
            objectWillChange.send()
        }
    }
    
    init(with model: Model) {
        self.model = model
    }
}
