//
//  RuleMakers.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 27/08/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol AnyValidationRuleMaker {
    var rules: [AnyFieldValidationRule] { get set }
}

public protocol MinLengthRuleSetter {
    func setMinLength(_ length: UInt)
}

public protocol MaxLengthRuleSetter {
    func setMaxLength(_ length: UInt)
}

public protocol LengthRuleSetter: MinLengthRuleSetter, MaxLengthRuleSetter { }

public protocol EmailRuleSetter {
    func expectEmail()
}

public protocol AllowedCharacterSetter {
    func onlyAllow(_ characterSet: CharacterSet)
}

public protocol CustomRuleSetter {
    func use(_ rule: AnyFieldValidationRule)
}

// MARK: - Impl

public extension MinLengthRuleSetter where Self: AnyValidationRuleMaker {
    func setMinLength(_ length: UInt) {
        // TODO: Implement
    }
}

public extension MaxLengthRuleSetter where Self: AnyValidationRuleMaker {
    func setMaxLength(_ length: UInt) {
        // TODO: Implement
    }
}

public extension EmailRuleSetter where Self: AnyValidationRuleMaker {
    func expectEmail() {
        // TODO: Implement
    }
}

public extension CustomRuleSetter where Self: AnyValidationRuleMaker {
    func use(_ rule: AnyFieldValidationRule) {
        // TODO: Implement
    }
}

public extension AllowedCharacterSetter where Self: AnyValidationRuleMaker {
    func onlyAllow(_ characterSet: CharacterSet) {
        // TODO: Implement
    }
}
