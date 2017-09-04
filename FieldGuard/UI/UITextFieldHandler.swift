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

public class UITextFieldHandler {
    
    public let field: UITextField
    
    public var fieldDescriptor: TextFieldDescriptor {
        didSet {
            self.validator = FieldValidator(
                inputAcceptanceRules: fieldDescriptor.inputAcceptanceRules,
                validationRules: fieldDescriptor.validationRules
            )
            if let stringMask = fieldDescriptor.stringMask {
                self.stringMaskStorage = StringMaskStorage(mask: stringMask)
            }
        }
    }
    
    private(set) var validator: FieldValidator
    
    private var previousValue: String? = nil
    
    private var stringMaskStorage: StringMaskStorage?
    
    private var stringFormatter: StringFormatterProtocol? {
        return fieldDescriptor.stringFormatter
    }
    
    init(field: UITextField, fieldDescriptor: TextFieldDescriptor) {
        self.field = field
        self.fieldDescriptor = fieldDescriptor
        
        self.validator = FieldValidator(
            inputAcceptanceRules: fieldDescriptor.inputAcceptanceRules,
            validationRules: fieldDescriptor.validationRules
        )
        
        if let stringMask = fieldDescriptor.stringMask {
            self.stringMaskStorage = StringMaskStorage(mask: stringMask)
        }
        
        self.previousValue = self.field.text
        self.field.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    @objc func valueChanged() {
        let nextValue: String?
        if let newValue = self.field.text {
            let unformatted = self.stringFormatter?.unformat(newValue)
            self.stringMaskStorage?.original = unformatted
            let formatted = self.stringMaskStorage?.masked
            nextValue = formatted
        } else {
            nextValue = nil
        }
        self.field.text = nextValue
    }
}
