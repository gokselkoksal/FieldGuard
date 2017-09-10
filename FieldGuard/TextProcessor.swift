//
//  TextProcessor.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 07/09/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class TextProcessor {
    
    struct TextValue: Equatable, CustomStringConvertible {
        
        let raw: String
        let masked: String
        let formatted: String
        let maskedFormatted: String
        
        static func ==(a: TextValue, b: TextValue) -> Bool {
            return a.raw == b.raw &&
                a.masked == b.masked &&
                a.formatted == b.formatted &&
                a.maskedFormatted == b.maskedFormatted
        }
        
        var description: String {
            return "\(raw) | \(masked) | \(formatted) | \(maskedFormatted)"
        }
    }
    
    var mask: StringMaskProtocol?
    var formatter: StringFormatterProtocol?
    
    var value: TextValue? {
        didSet {
            self.oldValue = oldValue
        }
    }
    
    private(set) var oldValue: TextValue?
    
    init(formatter: StringFormatterProtocol?, mask: StringMaskProtocol?) {
        self.formatter = formatter
        self.mask = mask
    }
    
    func setRawText(_ raw: String?) {
        if let raw = raw {
            self.value = TextProcessor.process(raw, mask: mask, formatter: formatter)
        } else {
            self.value = nil
        }
    }
    
    func revert() {
        self.value = oldValue
    }
    
    func changeCharacters(in range: NSRange, with replacement: String) {
        if let containsFormat = formatter?.checkRangeForFormatCharacters(range, value: value?.formatted ?? ""), containsFormat {
            return
        }
        if let value = value {
            let rawIndex = formatter?.translateToRawIndex(range.location) ?? range.location
            let rawRange = NSRange(location: rawIndex, length: range.length)
            let newRaw = (value.raw as NSString).replacingCharacters(in: rawRange, with: replacement)
            setRawText(newRaw)
        } else {
            if range.location == 0 {
                setRawText(replacement)
            }
        }
    }
    
    static func process(_ raw: String, mask: StringMaskProtocol?, formatter: StringFormatterProtocol?) -> TextValue {
        let masked = mask?.mask(raw) ?? raw
        let formatted = formatter?.format(raw) ?? raw
        let maskedFormatted = formatter?.format(masked) ?? masked
        return TextValue(raw: raw, masked: masked, formatted: formatted, maskedFormatted: maskedFormatted)
    }
}
