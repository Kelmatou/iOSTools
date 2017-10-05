//
//  ImageVision.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/4/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import CoreML
import Vision

@available(iOS 11.0, *)
public class ImageVision {
  
  /// Model used to recognize objects
  private var model: MLModel?
  
  init(_ model: MLModel) {
    self.model = model
  }
  
  /**
   Detect model objects from an image
   
   - parameter image: the picture to analyse
   - parameter maxResult: the maximum number of result returned
   
   - returns: a dictionary of possible model objects and the prediction accuracy [ "modelObject" : probability ] (nil is return is case of trouble)
              This probability is expressed as percentage
   */
  public func detect(in image: UIImage, maxResult: Int? = nil, completion: @escaping ([String : Float]?, GenericError?) -> Void) {
    guard let ciImage = CIImage(image: image) else {
      debugPrint("[ERROR]: Failed to convert image to CIImage")
      completion(nil, ImageError("Failed to convert image to CIImage"))
      return
    }
    
    guard let modelUnwrapped = model, let coreModel = try? VNCoreMLModel(for: modelUnwrapped) else {
      debugPrint("[ERROR]: Failed to load model")
      completion(nil, ModelError("Failed to load model"))
      return
    }
    
    let request = VNCoreMLRequest(model: coreModel) { request, error in
      guard let results = request.results as? [VNClassificationObservation] else {
        debugPrint("[ERROR] Unexpected result type")
        completion(nil, ModelError("Unexpected result type"))
        return
      }
      
      var resultsDictionnary: [String : Float] = [:]
      for result in results {
        resultsDictionnary[result.identifier] = result.confidence * 100
        if resultsDictionnary.count == maxResult {
          break
        }
      }
      
    }
    
    let handler = VNImageRequestHandler(ciImage: ciImage)
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        try handler.perform([request])
      } catch {
        debugPrint("[ERROR]: Failure during recognition: \(error)")
        completion(nil, ModelError("Failure during recognition \(error)"))
      }
    }
  }
  
  /**
   Detect model objects from an image
   
   - parameter image: the picture to analyse
   - parameter model: the model that represents objects to find
   - parameter maxResult: the maximum number of result returned
   
   - returns: a dictionary of possible model objects and the prediction accuracy [ "modelObject" : probability ] (nil is return is case of trouble)
   This probability is expressed as percentage
   */
  public static func detectModel(in image: UIImage, model: MLModel, maxResult: Int? = nil, completion: @escaping ([String : Float]?, GenericError?) -> Void) {
    let imageVisionObject: ImageVision = ImageVision(model)
    imageVisionObject.detect(in: image, maxResult: maxResult) { (result, error) in
      completion(result, error)
    }
  }
  
  /**
   Detect objects from an image. It is using MobileNet models
   
   - parameter image: the picture to analyse
   - parameter maxResult: the maximum number of result returned
   
   - returns: a dictionary of possible objects and the prediction accuracy [ "object" : probability ] (nil is return is case of trouble)
              This probability is expressed as percentage
   */
  public static func detectObject(in image: UIImage, maxResult: Int? = nil, completion: @escaping ([String : Float]?, GenericError?) -> Void) {
    let imageVisionObject: ImageVision = ImageVision(MobileNet().model)
    imageVisionObject.detect(in: image, maxResult: maxResult) { (result, error) in
      completion(result, error)
    }
  }
  
  /**
   Detect a room type from an image. It is using GoogLeNetPlaces models
   
   - parameter image: the picture to analyse
   - parameter maxResult: the maximum number of result returned
   
   - returns: a dictionary of possible room type and the prediction accuracy [ "room" : probability ] (nil is return is case of trouble)
              This probability is expressed as percentage
   */
  public static func detectPlaces(in image: UIImage, maxResult: Int? = nil, completion: @escaping ([String : Float]?, GenericError?) -> Void) {
    let imageVisionObject: ImageVision = ImageVision(GoogLeNetPlaces().model)
    imageVisionObject.detect(in: image, maxResult: maxResult) { (result, error) in
      completion(result, error)
    }
  }
}
