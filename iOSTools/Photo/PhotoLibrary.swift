//
//  PhotoLibrary.swift
//  iOSTools
//
//  Created by Antoine Clop on 7/26/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import UIKit

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  /**
   Will present a photo library view to let the user pick a photo
   Note: If you want to get the image picked, please copy paste this:
   
   public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      picker.dismiss(animated: true, completion: {
        //image
      })
    }
    else {
      //no image
    }
   }
   */
  public func openPhotoLibrary() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
      let imagePick = UIImagePickerController()
      imagePick.delegate = self
      imagePick.sourceType = UIImagePickerControllerSourceType.photoLibrary
      self.present(imagePick, animated: true, completion: nil)
    }
  }
}
