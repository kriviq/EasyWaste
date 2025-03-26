//
//  PickerViewModel.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 18.12.24.
//

import Foundation
import Combine
import UIKit

enum Picker {
    case library, camera
}

class PickerViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isShowingPicker: Bool = false
    @Published var picker: Picker = .library
}
