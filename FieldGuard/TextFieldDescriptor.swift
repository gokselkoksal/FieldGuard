//
//  UITextFieldValidator.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 27/08/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

func testAPI() {
    let descriptor = TextFieldDescriptor()
    descriptor.beforeValueChange { (maker) in
        maker.setMaxLength(5)
        maker.onlyAllow(.alphanumerics)
    }
    descriptor.afterValueChange { (maker) in
        maker.expectEmail()
    }
    descriptor.mask(first: 7)
    descriptor.mask(
        ranges: [NSRange(location: 0, length: 2)]
    )
    descriptor.format("# (###) ### ## ##")
}

public enum FieldEvent: UInt {
    case beforeValueChange
    case afterValueChange
}

public protocol BeforeValueChangeRuleSetter: MaxLengthRuleSetter, CustomRuleSetter, AllowedCharacterSetter { }
public protocol AfterValueChangeRuleSetter: LengthRuleSetter, EmailRuleSetter, CustomRuleSetter, AllowedCharacterSetter { }

private class BeforeValueChangeRuleMaker: AnyValidationRuleMaker, BeforeValueChangeRuleSetter {
    var rules: [AnyValidationRule] = []
}

private class AfterValueChangeRuleMaker: AnyValidationRuleMaker, AfterValueChangeRuleSetter {
    var rules: [AnyValidationRule] = []
}

public class TextFieldDescriptor {
    
    public let validator: FieldValidator = FieldValidator()
    public var formatter: StringFormatterProtocol? = nil
    public var mask: StringMaskProtocol? = nil
    
    public func beforeValueChange(_ configure: (_ maker: BeforeValueChangeRuleSetter) -> Void) {
        let maker = BeforeValueChangeRuleMaker()
        configure(maker)
        self.validator.addRules(maker.rules, forID: FieldEvent.beforeValueChange)
    }
    
    public func afterValueChange(_ customize: (_ maker: AfterValueChangeRuleSetter) -> Void) {
        let maker = AfterValueChangeRuleMaker()
        customize(maker)
        self.validator.addRules(maker.rules, forID: FieldEvent.afterValueChange)
    }
    
    public func format(_ pattern: String, token: Character = "#") {
        formatter = StringFormatter(pattern: pattern, valueCharacter: token)
    }
    
    public func mask(first characterCount: UInt, character: Character = "*") {
        mask(ranges: [NSRange(location: 0, length: Int(characterCount))], character: character)
    }
    
    public func mask(ranges: [NSRange], character: Character = "*") {
        mask = StringMask(ranges: ranges, character: character)
    }
}
