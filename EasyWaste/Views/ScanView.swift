//
//  ScanView.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 28.03.25.
//

import SwiftUI
import AVFoundation

struct ScanView: View {
    @State private var isShowingCamera = false
    @State private var detectedObjects: [DetectedObject] = []
    
    var body: some View {
        VStack {
            Button("Open Camera") {
                isShowingCamera = true
            }
            .sheet(isPresented: $isShowingCamera) {
                VisionObjectDetectionCameraView(detectedObjects: $detectedObjects)
            }
            
            // Display detected objects
            List(detectedObjects, id: \.id) { object in
                HStack {
                    Text(object.label)
                    Spacer()
                    Text("\(object.confidence, specifier: "%.2f")%")
                }
            }
        }
        .navigationTitle("Scan")
    }
}

//struct ScanView: View {
//    @State private var isShowingCamera = true
//    
//    var body: some View {
//        VStack {
//            Button("Open Camera") {
//                isShowingCamera = true
//            }
//            .sheet(isPresented: $isShowingCamera) {
//                CameraView()
//            }
//        }
//        .navigationTitle("Scan")
//    }
//}
