//
//  ScanView.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 28.03.25.
//

import SwiftUI
import AVFoundation

struct ScanView: View {
    //Initial state - set true to go directly to camera
    @State private var isShowingCamera = false
    
    var body: some View {
        VStack {
            Button("Open Camera") {
                isShowingCamera = true
            }
            .sheet(isPresented: $isShowingCamera) {
                CameraView()
            }
        }
        .navigationTitle("Scan")
    }
}

