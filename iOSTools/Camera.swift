//
//  Camera.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/26/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import UIKit
import AVFoundation

@objc public protocol CameraDelegate: class {
  
  @objc optional func didFinishCapture(_ cameraView: CameraView, image: UIImage?)
  @objc optional func didChangeCapturePosition(_ cameraView: CameraView, newOrientation: AVCaptureDevicePosition)
  @objc optional func willChangeCapturePosition(_ cameraView: CameraView, newOrientation: AVCaptureDevicePosition)
}

public class CameraView: UIView, UIImagePickerControllerDelegate {
  
  // MARK: - Variables
  
  private var captureSession = AVCaptureSession()
  private var sessionOutput = AVCapturePhotoOutput()
  private var previewLayer = AVCaptureVideoPreviewLayer()
  
  internal var imageTaken: UIImage?
  internal var receiverController: UIViewController?
  
  public weak var delegate: CameraDelegate?
  public var capturePosition: AVCaptureDevicePosition = .back
  
  // MARK: - Init
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupGesture()
    setupCamera()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupGesture()
    setupCamera()
  }
  
  // MARK: - Setup
  
  private func setupGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(switchCamera))
    tap.numberOfTapsRequired = 2
    self.addGestureRecognizer(tap)
  }
  
  private func setupCamera() {
    if let deviceSession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: capturePosition), let devices = deviceSession.devices {
      for device in devices {
        do {
          let input = try AVCaptureDeviceInput(device: device)
          if captureSession.canAddInput(input) {
            captureSession.addInput(input)
            if captureSession.canAddOutput(sessionOutput) {
              captureSession.addOutput(sessionOutput)
              previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
              previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
              previewLayer.connection.videoOrientation = .portrait
              self.layer.addSublayer(previewLayer)
              previewLayer.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
              previewLayer.bounds = self.frame
              captureSession.startRunning()
            }
          }
        }
        catch let error {
          debugPrint("[ERROR]: Camera setup failure: \(error)")
        }
      }
    }
  }
  
  // MARK: - Action
  
  public func capturePhoto() {
    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : sessionOutput.availablePhotoCodecTypes[0]])
    sessionOutput.capturePhoto(with: settings, delegate: self)
  }
  
  // MARK: - Camera
  
  public func switchCamera() {
    if captureSession.isRunning {
      if let currentCameraInput: AVCaptureInput = captureSession.inputs[0] as? AVCaptureInput {
        captureSession.removeInput(currentCameraInput)
        var newCamera: AVCaptureDevice
        if let currentCameraInput = currentCameraInput as? AVCaptureDeviceInput, currentCameraInput.device.position == .front {
          capturePosition = .back
        } else {
          capturePosition = .front
        }
        willChangeCapturePosition(self, newOrientation: capturePosition)
        let deviceSession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
        if let deviceSession = deviceSession {
          for device in deviceSession.devices {
            if device.position == capturePosition {
              newCamera = device
              do {
                let newVideoInput = try AVCaptureDeviceInput(device: newCamera)
                captureSession.addInput(newVideoInput)
                return
              }
              catch {
              }
            }
          }
        }
      }
    }
    didChangeCapturePosition(self, newOrientation: capturePosition)
  }
}

extension CameraView: AVCapturePhotoCaptureDelegate {
  
  public func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?)
  {
    let blockBuffer = CMSampleBufferGetDataBuffer(photoSampleBuffer!)
    var len = CMBlockBufferGetDataLength(blockBuffer!)
    var data: UnsafeMutablePointer<Int8>?
    CMBlockBufferGetDataPointer(blockBuffer!, 0, nil, &len, &data)
    let d = Data.init(bytes: data!, count: len)
    imageTaken = rotateUIImage(image: UIImage.init(data: d)!, angleDeg: 90.0)
    if let imageBefore = imageTaken, capturePosition == .front {
      imageTaken = mirrorUIImage(image: imageBefore)
    }
    didFinishCapture(self, image: imageTaken)
  }
  
  private func rotateUIImage(image: UIImage, angleDeg: CGFloat) -> UIImage {
    let size = CGSize(width: image.size.height, height: image.size.width)
    UIGraphicsBeginImageContext(size)
    let context : CGContext = UIGraphicsGetCurrentContext()!
    let rad = angleDeg * CGFloat(Double.pi) / 180.0
    context.rotate(by: rad)
    context.scaleBy(x: 1.0, y: -1.0)
    let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    context.draw(image.cgImage!, in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
  
  private func mirrorUIImage(image: UIImage) -> UIImage {
    let newImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored)
    return newImage
  }
}

extension CameraView: CameraDelegate {
  
  public func didFinishCapture(_ cameraView: CameraView, image: UIImage?) {
    if let delegate = delegate, let didFinishCapture = delegate.didFinishCapture {
      didFinishCapture(cameraView, image)
    }
  }
  
  public func didChangeCapturePosition(_ cameraView: CameraView, newOrientation: AVCaptureDevicePosition) {
    if let delegate = delegate, let didChangeCapturePosition = delegate.didChangeCapturePosition {
      didChangeCapturePosition(cameraView, newOrientation)
    }
  }
  
  public func willChangeCapturePosition(_ cameraView: CameraView, newOrientation: AVCaptureDevicePosition) {
    if let delegate = delegate, let willChangeCapturePosition = delegate.willChangeCapturePosition {
      willChangeCapturePosition(cameraView, newOrientation)
    }
  }
}
