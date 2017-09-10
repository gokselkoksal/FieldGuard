//
//  UITextFieldHandler.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 04/09/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import UIKit

// TODO: In progress

public class UITextFieldHandler: NSObject {
    
    public let field: UITextField
    
    public var fieldDescriptor: TextFieldDescriptor {
        didSet {
            self.validator = FieldValidator(
                inputAcceptanceRules: fieldDescriptor.inputAcceptanceRules,
                validationRules: fieldDescriptor.validationRules
            )
            self.textProcessor.formatter = fieldDescriptor.stringFormatter
            self.textProcessor.mask = fieldDescriptor.stringMask
        }
    }
    
    public fileprivate(set) var validator: FieldValidator
    
    fileprivate let textProcessor: TextProcessor
    
    init(field: UITextField, fieldDescriptor: TextFieldDescriptor) {
        self.field = field
        self.fieldDescriptor = fieldDescriptor
        
        self.textProcessor = TextProcessor(
            formatter: fieldDescriptor.stringFormatter,
            mask: fieldDescriptor.stringMask
        )
        
        self.validator = FieldValidator(
            inputAcceptanceRules: fieldDescriptor.inputAcceptanceRules,
            validationRules: fieldDescriptor.validationRules
        )
        
        super.init()
        self.field.delegate = self
    }
}

extension UITextFieldHandler: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text == textProcessor.value?.formatted else {
            return false
        }
        
        do {
            textProcessor.changeCharacters(in: range, with: string)
            try validator.setValue(textProcessor.value?.raw)
            return true
        } catch {
            textProcessor.revert()
            return false
        }
    }
}
