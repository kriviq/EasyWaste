//
//  CameraView.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 28.03.25.
//

import SwiftUI
import AVFoundation
import VisionKit
import Vision


class ObjectRecognitionViewModel: NSObject {
    var requests = [VNRequest]()
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        //TODO - BIG TODO
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
//                        self.drawVisionRequestResults(results)
                        print("Scanned results \(results)")
                    }
                })
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
}

struct DetectedObject: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Double
}

struct VisionObjectDetectionCameraView: UIViewControllerRepresentable {
    @Binding var detectedObjects: [DetectedObject]
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: VisionObjectDetectionCameraView
        var recognitionViewModel: ObjectRecognitionViewModel
        let visionSequenceHandler = VNSequenceRequestHandler()
        
        init(parent: VisionObjectDetectionCameraView, recognitionViewModel: ObjectRecognitionViewModel) {
            self.parent = parent
            self.recognitionViewModel = recognitionViewModel
            self.recognitionViewModel.setupVision()
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            let exifOrientation = exifOrientationFromDeviceOrientation()
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
            do {
                try imageRequestHandler.perform(recognitionViewModel.requests)
            } catch {
                print(error)
            }
        }
        
        public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
            let curDeviceOrientation = UIDevice.current.orientation
            let exifOrientation: CGImagePropertyOrientation
            
            switch curDeviceOrientation {
            case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
                exifOrientation = .left
            case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
                exifOrientation = .upMirrored
            case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
                exifOrientation = .down
            case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
                exifOrientation = .up
            default:
                exifOrientation = .up
            }
            return exifOrientation
        }
            
//            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//            
//            let request = VNRecognizeObjectsRequest { [weak self] request, error in
//                guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
//                
//                let detectedItems = results.compactMap { observation -> DetectedObject? in
//                    guard let topLabel = observation.labels.first else { return nil }
//                    
//                    return DetectedObject(
//                        label: topLabel.identifier,
//                        confidence: Double(topLabel.confidence) * 100
//                    )
//                }
//                
//                DispatchQueue.main.async {
//                    self?.parent.detectedObjects = detectedItems
//                }
//            }
//            
//            do {
//                try visionSequenceHandler.perform([request], on: pixelBuffer, orientation: .up)
//            } catch {
//                print("Failed to perform object detection: \(error)")
//            }
//        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, recognitionViewModel: ObjectRecognitionViewModel())
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return viewController
        }
        
        captureSession.addInput(input)
        
        // Setup video data output for object detection
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoDataOutput)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

//struct CameraView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        let captureSession = AVCaptureSession()
//        
//        guard let captureDevice = AVCaptureDevice.default(for: .video),
//              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
//            return viewController
//        }
//        
//        captureSession.addInput(input)
//        
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = viewController.view.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//        viewController.view.layer.addSublayer(previewLayer)
//        
//        DispatchQueue.global(qos: .background).async {
//            captureSession.startRunning()
//        }
//        
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}
