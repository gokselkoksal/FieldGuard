//
//  StringMask.swift
//  Lightning
//
//  Created by Göksel Köksal on 20/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public class StringMask: StringMaskProtocol {
    
    public let ranges: [NSRange]
    public let character: Character
    
    public init(ranges: [NSRange], character: Character = "*") {
        self.ranges = ranges
        self.character = character
    }
    
    public func mask(_ string: String) -> String {
        guard string.characters.count > 0 else { return string }
        let stringRanges = ranges.flatMap { string.zap_rangeIntersection(with: $0) }
        func shouldMaskIndex(_ index: String.Index) -> Bool {
            for range in stringRanges {
                if range.contains(index) {
                    return true
                }
            }
            return false
        }
        var result = ""
        var index = string.startIndex
        for char in string.characters {
            result += String(shouldMaskIndex(index) ? character : char)
            index = string.index(after: index)
        }
        return result
    }
}
