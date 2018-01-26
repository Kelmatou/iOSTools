//
//  Screenshot.swift
//  iOSTools
//
//  Created by Antoine Clop on 1/25/18.
//  Copyright © 2018 clop_a. All rights reserved.
//

import Foundation

extension UIView {
    
    public func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let screenshot: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
        }
        else {
            return nil
        }
    }
}
