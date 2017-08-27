//
//  FieldValidator.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 27/08/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public typealias ValidationID = AnyHashable

public class FieldValidator {
    
    public private(set) var rules: [ValidationID: [AnyValidationRule]]
    
    public private(set) var results: [ValidationID: ValidationResult] {
        didSet {
            self.status = FieldValidator.evaluateStatus(usingResults: results)
        }
    }
    
    public private(set) var status: ValidationResult {
        didSet {
            // TODO: Post notification.
        }
    }
    
    public init(rules: [ValidationID: [AnyValidationRule]] = [:]) {
        self.rules = rules
        var results: [ValidationID: ValidationResult] = [:]
        for (id, _) in rules {
            results[id] = .invalid([FieldGuardError.validationDidNotRunYet])
        }
        self.results = results
        self.status = FieldValidator.evaluateStatus(usingResults: results)
    }
    
    public func addRules(_ newRules: [AnyValidationRule], forID id: ValidationID) {
        var resultingRules = newRules
        
        if let existingRules = self.rules[id] {
            resultingRules.insert(contentsOf: existingRules, at: 0)
        }
        
        if resultingRules.isEmpty == false {
            self.rules[id] = resultingRules
            self.results[id] = .invalid([FieldGuardError.validationDidNotRunYet])
        }
    }
    
    public func removeRules(withID id: ValidationID) {
        self.rules[id] = nil
        self.results[id] = nil
    }
    
    public func validate(_ value: Any, usingRulesWithID id: ValidationID) -> ValidationResult {
        guard let filteredRules = rules[id] else {
            return ValidationResult.valid
        }
        
        var errors: [Error] = []
        for rule in filteredRules {
            errors.append(contentsOf: rule._validate(value).errors)
        }
        
        let result = ValidationResult(errors: errors)
        self.results[id] = result
        
        return result
    }
    
    public static func evaluateStatus(usingResults results: [ValidationID: ValidationResult]) -> ValidationResult {
        let resultValues = results.map { $0.value }
        return ValidationResult.merge(resultValues)
    }
}
