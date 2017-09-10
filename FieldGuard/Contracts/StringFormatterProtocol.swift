//
//  StringFormatterProtocol.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 17/09/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol StringFormatterProtocol {
    var formatCharacterIndexes: IndexSet { get }
    
    func format(_ value: String) -> String
    func unformat(_ value: String) -> String
}

public extension StringFormatterProtocol {
    
    public func translateToRawIndex(_ index: Int) -> Int {
        guard index >= 0 else {
            fatalError("[StringFormatter] Index can't be a negative value.")
        }
        let formatChars = formatCharacterIndexes.filteredIndexSet { $0 < index }
        return index - formatChars.count
    }
    
    public func checkRangeForFormatCharacters(_ range: NSRange, value: String) -> Bool {
        let valueBound = value.characters.count - 1
        let rangeBound = range.location + range.length - 1
        let upperBound = min(valueBound, rangeBound)
        let lowerBound = range.location
        
        guard lowerBound < upperBound else {
            return false
        }
        
        for index in lowerBound...upperBound {
            if formatCharacterIndexes.contains(index) {
                return true
            }
        }
        return false
    }
}
