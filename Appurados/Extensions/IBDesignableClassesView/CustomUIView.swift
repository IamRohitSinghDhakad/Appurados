//
//  CustomUIView.swift
//  TechnicalWorld
//
//  Created by Paras on 11/04/21.
//

import Foundation
//
//  UIView-Extension.swift
//

import UIKit

@IBDesignable
extension UIView {
     // Shadow
     @IBInspectable var shadow: Bool {
          get {
               return layer.shadowOpacity > 0.0
          }
          set {
               if newValue == true {
                self.addShadow(cornerRadius: self.layer.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], color: .darkGray, offset: CGSize(width: 0.0, height: 0.0), opacity: 0.6, shadowRadius: 2)
               }
          }
     }
    
    
    func addShadow(cornerRadius: CGFloat, maskedCorners: CACornerMask, color: UIColor, offset: CGSize, opacity: Float, shadowRadius: CGFloat) {
            self.layer.cornerRadius = cornerRadius
            self.layer.maskedCorners = maskedCorners
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOffset = offset
            self.layer.shadowOpacity = opacity
            self.layer.shadowRadius = shadowRadius
        }

//     fileprivate func addShadow(shadowColor: CGColor = UIColor.black.cgColor, shadowOffset: CGSize = CGSize(width: 0.0, height: 3.0), shadowOpacity: Float = 0.35, shadowRadius: CGFloat = 2.0) {
//          let layer = self.layer
//          layer.masksToBounds = false
//
//        layer.shadowColor = UIColor.black.cgColor//shadowColor
//        layer.shadowOffset = shadowOffset
//        layer.shadowRadius = shadowRadius
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
//
//          let backgroundColor = self.backgroundColor?.cgColor
//          self.backgroundColor = nil
//          layer.backgroundColor =  backgroundColor
//     }


     // Corner radius
     @IBInspectable var circle: Bool {
          get {
               return layer.cornerRadius == self.bounds.width*0.5
          }
          set {
               if newValue == true {
                    self.cornerRadius = self.bounds.width*0.5
               }
          }
     }

     @IBInspectable var cornerRadius: CGFloat {
          get {
               return self.layer.cornerRadius
          }

          set {
               self.layer.cornerRadius = newValue
          }
     }


     // Borders
     // Border width
     @IBInspectable
     public var borderWidth: CGFloat {
          set {
               layer.borderWidth = newValue
          }

          get {
               return layer.borderWidth
          }
     }

     // Border color
     @IBInspectable
     public var borderColor: UIColor? {
          set {
               layer.borderColor = newValue?.cgColor
          }

          get {
               if let borderColor = layer.borderColor {
                    return UIColor(cgColor: borderColor)
               }
               return nil
          }
     }
}
