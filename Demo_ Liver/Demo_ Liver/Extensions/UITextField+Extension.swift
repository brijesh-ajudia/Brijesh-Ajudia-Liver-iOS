//
//  UITextField+Extension.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import Foundation
import UIKit

extension UITextField {
    func setAttributePlaceHolder(title: String) {
        var placeHolder = NSMutableAttributedString()
        
        // Set the Font
        placeHolder = NSMutableAttributedString(string:title, attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15.0)!])
        
        // Set the color
        //placeHolder.addAttribute(NSAttributedString.Key.foregroundColor, value: textPlaceHolderColor, range:NSRange(location:0,length:title.count))
        
        // Add attribute
        self.attributedPlaceholder = placeHolder
        
    }
    
    func setAttributePlaceHolderWithFont(title: String, font: UIFont) {
        var placeHolder = NSMutableAttributedString()
        placeHolder = NSMutableAttributedString(string:title, attributes: [NSAttributedString.Key.font: font,
                                                                           NSAttributedString.Key.foregroundColor : UIColor.white])
        self.attributedPlaceholder = placeHolder
    }
    func setLeftViewMode() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.leftViewMode = .always
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    @IBInspectable var doneAccessory: Bool {
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}
