//
//  ValidationResult.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 27/08/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public enum ValidationResult {
    case valid
    case invalid([Error])
}

public extension ValidationResult {
    
    public init(errors: [Error]) {
        if errors.isEmpty {
            self = .valid
        } else {
            self = .invalid(errors)
        }
    }
    
    public var isValid: Bool {
        switch self {
        case .valid:
            return true
        default:
            return false
        }
    }
    
    public var errors: [Error] {
        switch self {
        case .invalid(let errors):
            return errors
        default:
            return []
        }
    }
    
    public static func merge(_ results: [ValidationResult]) -> ValidationResult {
        return results.reduce(.valid, +)
    }
    
    public static func +(a: ValidationResult, b: ValidationResult) -> ValidationResult {
        switch (a, b) {
        case (.valid, .valid):
            return .valid
        case (.valid, .invalid(let errors)):
            return .invalid(errors)
        case (.invalid(let errors), .valid):
            return .invalid(errors)
        case (.invalid(let errors1), .invalid(let errors2)):
            return .invalid(errors1 + errors2)
        }
    }
}
