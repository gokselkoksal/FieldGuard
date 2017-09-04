//
//  Test.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 04/09/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

func testAPI() {
    var descriptor = TextFieldDescriptor()
    descriptor.makeInputAcceptanceRules { (maker) in
        maker.setMaxLength(5)
        maker.onlyAllow(.alphanumerics)
    }
    descriptor.makeValidationRules { (maker) in
        maker.expectEmail()
    }
    descriptor.mask(first: 7)
    descriptor.mask(
        ranges: [NSRange(location: 0, length: 2)]
    )
    descriptor.format("# (###) ### ## ##")
    
    let validator = FieldValidator(
        inputAcceptanceRules: descriptor.inputAcceptanceRules,
        validationRules: descriptor.validationRules
    )
    
    do {
        try validator.setValue("test")
    } catch {
        // Typing rules failed.
    }
}
