//
//  ValidationRule.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 27/08/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol AnyValidationRule {
    var error: Error { get }
    func _validate(_ value: Any) -> ValidationResult
}

public protocol ValidationRule: AnyValidationRule {
    associatedtype Value
    func validate(_ value: Value) -> ValidationResult
}

// MARK: -

public extension ValidationRule {
    func _validate(_ value: Any) -> ValidationResult {
        guard let value = value as? Value else {
            return ValidationResult.invalid([FieldGuardError.valueTypeMismatch])
        }
        return validate(value)
    }
}
