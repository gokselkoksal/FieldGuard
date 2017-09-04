//
//  FieldValidator.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 04/09/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public class FieldValidator {
    
    public enum Error: Swift.Error {
        case cannotAcceptValue([Swift.Error])
    }
    
    public var inputAcceptanceRules: [AnyFieldValidationRule] = []
    public var validationRules: [AnyFieldValidationRule] = []
    public private(set) var value: Any?
    public let statusObservers: ObserverRegistry<ValidationResult> = ObserverRegistry<ValidationResult>()
    
    public private(set) var status: ValidationResult {
        didSet {
            statusObservers.notify(withValue: status)
        }
    }
    
    public init(inputAcceptanceRules: [AnyFieldValidationRule],
                validationRules: [AnyFieldValidationRule],
                initialValue: Any? = nil) {
        self.inputAcceptanceRules = inputAcceptanceRules
        self.validationRules = validationRules
        self.value = initialValue
        self.status = FieldValidator.validate(initialValue, withRules: validationRules)
    }
    
    public func setValue(_ value: Any?) throws {
        switch validateCandidateValue(value) {
        case .valid:
            self.value = value
            self.status = validateAcceptedValue(value)
        case .invalid(let errors):
            throw Error.cannotAcceptValue(errors)
        }
    }
}

private extension FieldValidator {
    
    func validateCandidateValue(_ value: Any?) -> ValidationResult {
        return FieldValidator.validate(value, withRules: inputAcceptanceRules)
    }
    
    func validateAcceptedValue(_ value: Any?) -> ValidationResult {
        return FieldValidator.validate(value, withRules: validationRules)
    }
    
    static func validate(_ value: Any?, withRules rules: [AnyFieldValidationRule]) -> ValidationResult {
        let result = rules
            .map({ $0._validate(value) })
            .reduce(ValidationResult.valid, +)
        return result
    }
}
