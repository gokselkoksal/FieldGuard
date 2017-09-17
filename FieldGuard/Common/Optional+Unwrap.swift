//
//  Optional+Unwrap.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 17/09/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

struct CannotUnwrapNilOptionalError: Error { }

extension Optional {
    
    func unwrap() throws -> Wrapped {
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            throw CannotUnwrapNilOptionalError()
        }
    }
}
