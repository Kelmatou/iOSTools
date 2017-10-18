//
//  ImageVisionError.swift
//  iOSTools
//
//  Created by Antoine Clop on 10/5/17.
//  Copyright © 2017 clop_a. All rights reserved.
//

import Foundation

class ModelError: GenericError
{
  override init(_ msg: String) {
    super.init(description: msg, failure: msg, recovery: "Fix and rebuild your model", help: "Fix and rebuild your model")
  }
}

class ImageError: GenericError
{
  override init(_ msg: String) {
    super.init(description: msg, failure: msg, recovery: "Recreate your image", help: "Recreate your image with a standard format (png, jpg...)")
  }
}
