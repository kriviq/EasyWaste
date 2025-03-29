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


class ObjectRecognitionViewModel: NSObject, ObservableObject {
    var requests = [VNRequest]()
    @Published var observations: [DetectedObject]? = nil
    
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
                        self.processResults(results as! [VNRecognizedObjectObservation])
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
    
    private func processResults(_ results: [VNRecognizedObjectObservation]) {
        let detectedObjects = results.map { observation -> DetectedObject in
            let label = observation.labels.first?.identifier ?? "Unknown"
            let confidence = observation.confidence
            let boundingBox = observation.boundingBox
            
            return DetectedObject(
                label: label,
                confidence: confidence,
                boundingBox: boundingBox
            )
        }
        self.observations = detectedObjects
        
        //           DispatchQueue.main.async {
        //               // Update UI with detected objects
        //               NotificationCenter.default.post(
        //                   name: .detectedObjectsUpdated,
        //                   object: detectedObjects
        //               )
        //           }
    }
    
}

struct DetectedObject: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let boundingBox: CGRect
}

struct VisionObjectDetectionCameraView: UIViewControllerRepresentable {
    @Binding var detectedObjects: [DetectedObject]
    @ObservedObject var recognitionViewModel: ObjectRecognitionViewModel = ObjectRecognitionViewModel()
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: VisionObjectDetectionCameraView
        var recognitionViewModel: ObjectRecognitionViewModel
        let visionSequenceHandler = VNSequenceRequestHandler()
        var overlayView: DetectionOverlayView?
        
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
//                self.parent.detectedObjects = self.recognitionViewModel.object
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
        Coordinator(parent: self, recognitionViewModel: recognitionViewModel)
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
        
        // Add the overlay view
        let overlayView = DetectionOverlayView(frame: viewController.view.bounds)
        overlayView.backgroundColor = .clear
        viewController.view.addSubview(overlayView)
        context.coordinator.overlayView = overlayView
        
        // Handle view layout changes
        viewController.view.layoutSubviews()
        
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print("Update VC called \(recognitionViewModel.observations)")
        guard let obserations = recognitionViewModel.observations else { return }
        if let overlayView = context.coordinator.overlayView {
                    overlayView.frame = uiViewController.view.bounds
            overlayView.updateWithDetectedObjects(obserations)
                }
    }
}

class DetectionOverlayView: UIView {
    private var detectedObjects: [DetectedObject] = []
    
    func updateWithDetectedObjects(_ objects: [DetectedObject]) {
        self.detectedObjects = objects
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Clear the overlay
        context.clear(rect)
        
        for object in detectedObjects {
            // Convert normalized coordinates to view coordinates
            // Vision's coordinate system has (0,0) at the bottom-left
            // UIKit's coordinate system has (0,0) at the top-left
            let viewBox = CGRect(
                x: object.boundingBox.origin.x * bounds.width,
                y: (1 - object.boundingBox.origin.y - object.boundingBox.height) * bounds.height,
                width: object.boundingBox.width * bounds.width,
                height: object.boundingBox.height * bounds.height
            )
            let percentage = String(format: "%.1f", 100*(object.confidence))
            var strokeColor = UIColor.red
            if object.confidence > 0.5 {
                strokeColor = UIColor.orange
            }
            if object.confidence > 0.8 {
                strokeColor = UIColor.green
            }
            // Draw bounding box
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(3.0)
            context.stroke(viewBox)
            
            // Create label background
            
            let labelText = "\(object.label) \(percentage)%"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.white
            ]
            let textSize = labelText.size(withAttributes: attributes)
            
            let labelBackground = CGRect(
                x: viewBox.origin.x,
                y: viewBox.origin.y - textSize.height - 5,
                width: textSize.width + 10,
                height: textSize.height + 5
            )
            
            // Draw label background
            context.setFillColor(UIColor.red.cgColor)
            context.fill(labelBackground)
            
            // Draw label text
            labelText.draw(at: CGPoint(
                x: labelBackground.origin.x + 5,
                y: labelBackground.origin.y + 2
            ), withAttributes: attributes)
        }
    }
    
    // Make sure the overlay adapts to orientation and size changes
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
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
