//
//  UITextFieldValidator.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 27/08/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol BeforeValueChangeRuleSetter: MaxLengthRuleSetter, CustomRuleSetter, AllowedCharacterSetter { }
public protocol AfterValueChangeRuleSetter: LengthRuleSetter, EmailRuleSetter, CustomRuleSetter, AllowedCharacterSetter { }

private class BeforeValueChangeRuleMaker: AnyValidationRuleMaker, BeforeValueChangeRuleSetter {
    var rules: [AnyFieldValidationRule] = []
}

private class AfterValueChangeRuleMaker: AnyValidationRuleMaker, AfterValueChangeRuleSetter {
    var rules: [AnyFieldValidationRule] = []
}

public struct TextFieldDescriptor {
    
    public var inputAcceptanceRules: [AnyFieldValidationRule] = []
    public var validationRules: [AnyFieldValidationRule] = []
    public var stringFormatter: StringFormatterProtocol? = nil
    public var stringMask: StringMaskProtocol? = nil
    
    public mutating func makeInputAcceptanceRules(_ configure: (_ maker: BeforeValueChangeRuleSetter) -> Void) {
        let maker = BeforeValueChangeRuleMaker()
        configure(maker)
        self.inputAcceptanceRules = maker.rules
    }
    
    public mutating func makeValidationRules(_ customize: (_ maker: AfterValueChangeRuleSetter) -> Void) {
        let maker = AfterValueChangeRuleMaker()
        customize(maker)
        self.validationRules = maker.rules
    }
    
    public mutating func format(_ pattern: String, token: Character = "#") {
        self.stringFormatter = StringFormatter(pattern: pattern, valueCharacter: token)
    }
    
    public mutating func mask(first characterCount: UInt, character: Character = "*") {
        self.mask(ranges: [NSRange(location: 0, length: Int(characterCount))], character: character)
    }
    
    public mutating func mask(ranges: [NSRange], character: Character = "*") {
        self.stringMask = StringMask(ranges: ranges, character: character)
    }
}
