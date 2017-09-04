//
//  FormValidator.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 04/09/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public class FormValidator {
    
    public var fieldValidators: [FieldValidator]
    public var formRules: [FormValidationRule]
    
    public fileprivate(set) var status: ValidationResult {
        didSet {
            statusObservers.notify(withValue: status)
        }
    }
    
    public let statusObservers: ObserverRegistry<ValidationResult> = ObserverRegistry<ValidationResult>()
    
    public init(fieldValidators: [FieldValidator],
                formRules: [FormValidationRule] = []) {
        self.fieldValidators = fieldValidators
        self.formRules = formRules
        self.status = FormValidator.mergeStatuses(of: fieldValidators)
        self.addStatusObservers()
    }
    
    deinit {
        self.removeStatusObservers()
    }
    
    public func validate() -> ValidationResult {
        status = status + FormValidator.validate(with: formRules)
        return status
    }
}

private extension FormValidator {
    
    func updateStatus() {
        status = FormValidator.mergeStatuses(of: fieldValidators)
    }
    
    func addStatusObservers() {
        for fieldValidator in fieldValidators {
            fieldValidator.statusObservers.addObserver(self) { [weak self] (status) in
                self?.updateStatus()
            }
        }
    }
    
    func removeStatusObservers() {
        for fieldValidator in fieldValidators {
            fieldValidator.statusObservers.removeObserver(self)
        }
    }
    
    static func validate(with formRules: [FormValidationRule]) -> ValidationResult {
        let result = formRules
            .map({ $0.validate() })
            .reduce(ValidationResult.valid, +)
        return result
    }
    
    static func mergeStatuses(of fieldValidators: [FieldValidator]) -> ValidationResult {
        let status = fieldValidators
            .map({ $0.status })
            .reduce(ValidationResult.valid, +)
        return status
    }
}
