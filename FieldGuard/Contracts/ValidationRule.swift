//
//  ValidationRule.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 27/08/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol FormValidationRule {
    var error: Error { get set }
    func validate() -> ValidationResult
}

public protocol AnyFieldValidationRule {
    var error: Error { get set }
    func _validate(_ value: Any?) -> ValidationResult
}

public protocol FieldValidationRule: AnyFieldValidationRule {
    associatedtype Value
    func validate(_ value: Value?) -> ValidationResult
}

// MARK: -

public extension FieldValidationRule {
    func _validate(_ value: Any?) -> ValidationResult {
        guard let value = value as? Value? else {
            return ValidationResult.invalid([FieldGuardError.valueTypeMismatch])
        }
        return validate(value)
    }
}
