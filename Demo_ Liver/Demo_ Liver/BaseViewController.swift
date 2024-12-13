//
//  BaseViewController.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    var allTextField: [UITextField] = []
    var allTextView: [UITextView] = []
    
    var beginTextField:((_ textField: UITextField) -> Bool)?
    var beginTextView:((_ textView: UITextView) -> Bool)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestureIfTextfieldExists()
        self.addGestureIfTextViewExists()
    }
    
    //MARK: - AddGestureIfTextfieldExists
    func addGestureIfTextfieldExists() {
        self.allTextField = getAllTextFields(fromView : self.view)
        if  self.allTextField.count > 0 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureClickEvent(_:)))
            tapGesture.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tapGesture)
            self.setKeyboardIfTextFieldExists()
        }
    }
    
    func addGestureIfTextViewExists() {
        self.allTextView = getAllTextViews(fromView: self.view)
        if self.allTextView.count > 0 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureClickEvent(_:)))
            tapGesture.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tapGesture)
            self.setKeyboardIfTextViewExists()
        }
    }
    
    
    
    @objc func tapGestureClickEvent(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.compactMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
        }.flatMap({$0})
    }
    
    func getAllTextViews(fromView view: UIView)-> [UITextView] {
        return view.subviews.compactMap { (view) -> [UITextView]? in
            if view is UITextView {
                return [(view as! UITextView)]
            } else {
                return getAllTextViews(fromView: view)
            }
        }.flatMap({$0})
    }
    
    
    //MARK: - Set Keyboard Type
    func setKeyboardIfTextFieldExists() {
        for i in 0 ..< self.allTextField.count {
            let textfield = self.allTextField[i]
            textfield.delegate = self
            textfield.tag = i
            textfield.returnKeyType = i == self.allTextField.count - 1 ? .done : .next
            
            switch (textfield.textContentType) {
            case UITextContentType.emailAddress:
                textfield.keyboardType = .emailAddress
            case UITextContentType.password:
                textfield.keyboardType = .default
                textfield.isSecureTextEntry = true
            case UITextContentType.telephoneNumber:
                textfield.keyboardType = .numberPad
            default:
                textfield.keyboardType = .default
            }
        }
    }
    
    func setKeyboardIfTextViewExists() {
        for i in 0 ..< self.allTextView.count {
            let textfield = self.allTextView[i]
            textfield.delegate = self
            textfield.tag = i
            textfield.returnKeyType = i == self.allTextView.count - 1 ? .done : .next
            
            switch (textfield.textContentType) {
            case UITextContentType.emailAddress:
                textfield.keyboardType = .emailAddress
            case UITextContentType.password:
                textfield.keyboardType = .default
                textfield.isSecureTextEntry = true
            case UITextContentType.telephoneNumber:
                textfield.keyboardType = .numberPad
            default:
                textfield.keyboardType = .default
            }
        }
    }
    
}

extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let returnValue = self.beginTextField?(textField) {
            return returnValue
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nextTextField(textField: textField)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.textContentType == UITextContentType.telephoneNumber {
            return range.location < 15
        }
        else {
            return true
        }
    }
    func nextTextField(textField: UITextField) {
        let nextTag = textField.tag + 1
        if let nextResponder = self.view.viewWithTag(nextTag) as? UITextField {
            if nextResponder.isUserInteractionEnabled {
                nextResponder.becomeFirstResponder()
            }
            else {
                self.nextTextField(textField: nextResponder)
            }
        } else {
            textField.resignFirstResponder()
        }
    }
}

extension BaseViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let returnValue = self.beginTextView?(textView) {
            return returnValue
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.textContentType == UITextContentType.telephoneNumber {
            return range.location < 15
        }
        else {
            return true
        }
    }
}

