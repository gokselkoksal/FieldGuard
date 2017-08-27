//
//  Errors.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 27/08/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public enum FieldGuardError: Swift.Error {
    case valueTypeMismatch
    case validationDidNotRunYet
}
