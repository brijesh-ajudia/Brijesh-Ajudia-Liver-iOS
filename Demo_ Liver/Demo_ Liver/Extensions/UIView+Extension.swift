//
//  UIView+Extension.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import Foundation
import UIKit

// MARK: - View extension
extension UIView {
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var cornerRadiuss: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var roundCorners: Bool {
        get {
            return self.roundCorners
        }
        set {
            self.cornerRadiuss = self.frame.height/2
        }
    }
    
    @IBInspectable
    var roundUpperCorners: Bool {
        get {
            return self.roundUpperCorners
        }
        set {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    @IBInspectable
    var roundLowerCorners: Bool {
        get {
            return self.roundLowerCorners
        }
        set {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @IBInspectable
    var roundLeftCorners: Bool {
        get {
            return self.roundLeftCorners // No need to implement getter, as it's only for setting
        }
        set {
            if newValue {
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            }
        }
    }
    
    @IBInspectable
    var roundRightCorners: Bool {
        get {
            return self.roundRightCorners // No need to implement getter, as it's only for setting
        }
        set {
            if newValue {
                self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            layer.shadowOpacity
        }
        set {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            layer.shadowRadius
        }
        set {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var bgHex: String {
        get {
            return self.backgroundColor?.toHex ?? ""
        }
        set {
            self.backgroundColor = UIColor(hex: newValue)
        }
    }
    
    func setDropShadow(cornerRadius: CGFloat, x: CGFloat, y: CGFloat, shadowColor: UIColor, blur: CGFloat, spread: CGFloat, opacity: CGFloat) {
        self.layer.masksToBounds = false
        self.cornerRadiuss = cornerRadius
        self.layer.shadowColor = shadowColor.withAlphaComponent(opacity * 2).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: x * 2, height: y * 2)
        self.layer.shadowRadius = spread * 2
        self.layoutIfNeeded()
    }
    
    func dropShadow(scale: Bool = true) {
        self.cornerRadiuss = 18.0
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 20
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
    
    //    func dropShadow(scale: Bool = true) {
    //       layer.masksToBounds = false
    //       layer.shadowColor = UIColor.black.cgColor
    //       layer.shadowOpacity = 0.5
    //       layer.shadowOffset = CGSize(width: -1, height: 1)
    //       layer.shadowRadius = 1
    //
    //       layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    //       layer.shouldRasterize = true
    //       layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    //     }
    
    // OUTPUT 2
    func dropShadow(cornerRadius: CGFloat, color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.cornerRadiuss = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func fadeIn(duration: TimeInterval = 0.3,
                delay: TimeInterval = 0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.3,
                 delay: TimeInterval = 0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .topToBottom:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .diagonal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0) // Top-left corner
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)   // Bottom-right corner
        }
        
        // Set the locations for 80% and 20% distribution
        gradient.locations = [0.0, 0.4]
        
        backgroundColor = .clear
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func showNoResultView(message: String = "No results found!") {
        DispatchQueue.main.async {
            let label = UILabel(frame: self.bounds)
            label.text = message
            label.font = UIFont.systemFont(ofSize: 24.0)
            label.tag = 9999
            label.textAlignment = .center
            self.addSubview(label)
            label.bringSubviewToFront(self)
        }
    }
    func hideNoResultView() {
        DispatchQueue.main.async {
            if let view = self.viewWithTag(9999) {
                view.removeFromSuperview()
            }
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.7
        animation.repeatCount = 1
        animation.autoreverses = false
        animation.values = [-8.0, 8.0, -8.0, 8.0, -4.0, 4.0,-2.0, 2.0, 0.0, 0.0]
        self.layer.add(animation, forKey: "position")
    }
    
    func applyGradientBackground(colors: [CGColor], locations: [NSNumber] = [0.0, 0.5, 0.9]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func createDottedLine(color: CGColor) {
        self.backgroundColor = .clear
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineCap = .round
        caShapeLayer.lineWidth = 1
        caShapeLayer.lineDashPattern = [3,5]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.bounds.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    
}

enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
    case diagonal
}

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}

extension UIView {
    
    func onClick(target: Any, _ selector: Selector) {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: selector)
        addGestureRecognizer(tap)
    }
    
    func addTapGesture(action : @escaping ()->Void ){
        let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        sender.action!()
    }
    
}
