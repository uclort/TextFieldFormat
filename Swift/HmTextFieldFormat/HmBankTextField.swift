//
//  HmBankTextField.swift
//  chowRent
//
//  Created by HouMeng on 2019/4/13.
//  Copyright © 2019 eallcn. All rights reserved.
//

import UIKit

class HmBankTextField: UITextField, UITextFieldDelegate {
    
    private let placeholderSpace: NSString = " "
    
    public var plainPhoneNum: String {
        get {
            return self._noneSpaseString(string: self.text! as NSString)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let phStr = placeholderSpace
        let phChar = phStr.character(at: 0)
        let text = textField.text! as NSString
        if string == "" {
            if range.length == 1 {
                if range.location == text.length - 1 {
                    if text.character(at: text.length - 1) == phChar {
                        textField.deleteBackward()
                    }
                    return true
                } else {
                    var offset = range.location
                    if range.location < text.length && text.character(at: range.location) == phChar && textField.selectedTextRange?.isEmpty == true {
                        textField.deleteBackward()
                        offset -= 1
                    }
                    textField.deleteBackward()
                    textField.text = self._parseString(string: textField.text! as NSString)
                    let newPos = textField.position(from: textField.beginningOfDocument, offset: offset)!
                    textField.selectedTextRange = textField.textRange(from: newPos, to: newPos)
                    return false
                }
            }else if range.length > 1 {
                var isLast = false
                if range.location + range.length == textField.text?.count {
                    isLast = true
                }
                textField.deleteBackward()
                textField.text = self._parseString(string: textField.text! as NSString)
                var offset = range.location
                if (range.location == 4 || range.location  == 9 || range.location  == 14 || range.location  == 19) {
                    offset += 1
                }
                if isLast == true {
                    
                }else {
                    let newPos = textField.position(from: textField.beginningOfDocument, offset: offset)!
                    textField.selectedTextRange = textField.textRange(from: newPos, to: newPos)
                }
                return false
            }else {
                return true
            }
        }else if string.count > 0 {
            if self._noneSpaseString(string: textField.text! as NSString).count + string.count - range.length > 20 {
                return false
            }
            if self._isNum(checkedNumString: string as NSString) == false {
                return false
            }
            textField.insertText(string)
            textField.text = self._parseString(string: textField.text! as NSString)
            var offset = range.location + string.count
            if (range.location == 4 || range.location  == 9 || range.location  == 14 || range.location  == 19) {
                offset += 1
            }
            let newPos = textField.position(from: textField.beginningOfDocument, offset: offset)!
            textField.selectedTextRange = textField.textRange(from: newPos, to: newPos)
            return false
            
        }else {
            return true
        }
    }
    
    private func _parseString(string: NSString) -> String {
        if string == "" {
            return ""
        }
        let mStr = NSMutableString.init(string: string.replacingOccurrences(of: placeholderSpace as String, with: ""))
        if mStr.length > 4 {
            mStr.insert(placeholderSpace as String, at: 4)
        }
        if mStr.length > 9 {
            mStr.insert(placeholderSpace as String, at: 9)
        }
        if mStr.length > 14 {
            mStr.insert(placeholderSpace as String, at: 14)
        }
        if mStr.length > 19 {
            mStr.insert(placeholderSpace as String, at: 19)
        }
        return mStr as String
    }
    
    private func _noneSpaseString(string: NSString) -> String {
        return string.replacingOccurrences(of: placeholderSpace as String, with: "")
    }
    
    private func _isNum(checkedNumString: NSString) -> Bool {
        var checkedNum = checkedNumString
        if checkedNum == "" {
            return false
        }
        checkedNum = checkedNum.trimmingCharacters(in: NSCharacterSet.decimalDigits) as NSString
        if checkedNum.length > 0 {
            return false
        }
        return true
    }
}
