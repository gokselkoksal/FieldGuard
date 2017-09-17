//
//  TextProcessorTests.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 07/09/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import XCTest
@testable import FieldGuard

class TextProcessorTests: XCTestCase {
    
    var mask: StringMask!
    var formatter: StringFormatter!
    var p: TextProcessor!
    
    override func setUp() {
        super.setUp()
        mask = StringMask(ranges: [NSRange(location: 0, length: 7)])
        formatter = StringFormatter(pattern: "# (###) ### ## ##")
        p = TextProcessor(formatter: formatter, mask: mask)
    }
    
    func testTyping() throws {
        typealias TestCase = (input: String, expected: TextProcessor.TextValue)
        
        let testCases: [TestCase] = [
            ("0", .init(raw: "0", masked: "*", formatted: "0", maskedFormatted: "*")),
            ("5", .init(raw: "05", masked: "**", formatted: "0 (5", maskedFormatted: "* (*")),
            ("3", .init(raw: "053", masked: "***", formatted: "0 (53", maskedFormatted: "* (**")),
            ("0", .init(raw: "0530", masked: "****", formatted: "0 (530", maskedFormatted: "* (***")),
            ("9", .init(raw: "05309", masked: "*****", formatted: "0 (530) 9", maskedFormatted: "* (***) *")),
            ("9", .init(raw: "053099", masked: "******", formatted: "0 (530) 99", maskedFormatted: "* (***) **")),
            ("9", .init(raw: "0530999", masked: "*******", formatted: "0 (530) 999", maskedFormatted: "* (***) ***")),
            ("8", .init(raw: "05309998", masked: "*******8", formatted: "0 (530) 999 8", maskedFormatted: "* (***) *** 8")),
            ("8", .init(raw: "053099988", masked: "*******88", formatted: "0 (530) 999 88", maskedFormatted: "* (***) *** 88")),
            ("7", .init(raw: "0530999887", masked: "*******887", formatted: "0 (530) 999 88 7", maskedFormatted: "* (***) *** 88 7")),
            ("7", .init(raw: "05309998877", masked: "*******8877", formatted: "0 (530) 999 88 77", maskedFormatted: "* (***) *** 88 77"))
        ]
        
        for testCase in testCases {
            let index = p.value?.formatted.characters.count ?? 0
            let range = NSRange(location: index, length: 0)
            p.changeCharacters(in: range, with: testCase.input)
            let value = try p.value.unwrap()
            XCTAssertEqual(value, testCase.expected)
            print("Comparing: \n--\n\(value)\n--\n\(testCase.expected)\n----")
        }
    }
    
    func testSetRawText() {
        let expected = TextProcessor.TextValue(
            raw: "05302929988",
            masked: "*******9988",
            formatted: "0 (530) 292 99 88",
            maskedFormatted: "* (***) *** 99 88"
        )
        p.setRawText(expected.raw)
        XCTAssertEqual(p.value, expected)
    }
    
    func testChangeInRange_start() {
        let expected = TextProcessor.TextValue(
            raw: "15302929988",
            masked: "*******9988",
            formatted: "1 (530) 292 99 88",
            maskedFormatted: "* (***) *** 99 88"
        )
        p.setRawText("05302929988")
        p.changeCharacters(in: NSRange(location: 0, length: 1), with: "1")
        XCTAssertEqual(p.value, expected)
    }
    
    func testChangeInRange_middle() {
        let expected = TextProcessor.TextValue(
            raw: "05302924488",
            masked: "*******4488",
            formatted: "0 (530) 292 44 88",
            maskedFormatted: "* (***) *** 44 88"
        )
        p.setRawText("05302929988")
        p.changeCharacters(in: NSRange(location: 12, length: 2), with: "44")
        XCTAssertEqual(p.value, expected)
    }
    
    func testChangeInRange_end() {
        let expected = TextProcessor.TextValue(
            raw: "05302929944",
            masked: "*******9944",
            formatted: "0 (530) 292 99 44",
            maskedFormatted: "* (***) *** 99 44"
        )
        p.setRawText("05302929988")
        p.changeCharacters(in: NSRange(location: 15, length: 2), with: "44")
        XCTAssertEqual(p.value, expected)
    }
    
    func testChangeInRange_overflow() {
        let expected = TextProcessor.TextValue(
            raw: "05302929984444",
            masked: "*******9984444",
            formatted: "0 (530) 292 99 84444",
            maskedFormatted: "* (***) *** 99 84444"
        )
        p.setRawText("05302929988")
        p.changeCharacters(in: NSRange(location: 16, length: 1), with: "4444")
        XCTAssertEqual(p.value, expected)
    }
}
