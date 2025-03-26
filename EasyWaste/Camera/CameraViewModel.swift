//
//  CameraViewModel.swift
//  EasyWaste
//
//  Created by Ivan Yanakiev on 16.12.24.
//
import Foundation
import AVFoundation
import UIKit
import SwiftUI
import Combine

class CameraViewModel: ObservableObject {
 
  // Reference to the CameraManager.
  @ObservedObject var cameraManager = CameraManager()
 
  // Published properties to trigger UI updates.
  @Published var isFlashOn = false
  @Published var showAlertError = false
  @Published var showSettingAlert = false
  @Published var isPermissionGranted: Bool = false
 
//  var alertError: AlertError?

  // Reference to the AVCaptureSession.
  var session: AVCaptureSession = .init()

  // Cancellable storage for Combine subscribers.
  private var cancelables = Set<AnyCancellable>()
 
  init() {
    // Initialize the session with the cameraManager's session.
    session = cameraManager.session
  }

  deinit {
    // Deinitializer to stop capturing when the ViewModel is deallocated.
    cameraManager.stopCapturing()
  }
 
  // Setup Combine bindings for handling publisher's emit values
  func setupBindings() {
//      $cameraManager.$shouldShowAlertView.sink { [weak self] value in
//      // Update alertError and showAlertError based on cameraManager's state.
////      self?.alertError = self?.cameraManager.alertError
//      self?.showAlertError = value
//    }
//    .store(in: &cancelables)
  }
 
  // Check for camera device permission.
  func checkForDevicePermission() {
    let videoStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    if videoStatus == .authorized {
       // If Permission granted, configure the camera.
       isPermissionGranted = true
       configureCamera()
    } else if videoStatus == .notDetermined {
       // In case the user has not been asked to grant access we request permission
       AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { _ in })
    } else if videoStatus == .denied {
       // If Permission denied, show a setting alert.
       isPermissionGranted = false
       showSettingAlert = true
    }
  }
 
  // Configure the camera through the CameraManager to show a live camera preview.
  func configureCamera() {
     cameraManager.configureCaptureSession()
  }
}
