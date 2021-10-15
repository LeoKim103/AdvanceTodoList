//
//  AssetTests.swift
//  AdvanceTodoListTests
//
//  Created by Leo Kim on 15/10/2021.
//

import XCTest
@testable import AdvanceTodoList

class AssetTests: XCTestCase {
    func testColorExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load '\(color)' from assets")
        }
    }

    func testJSONLoadCorrectly() {
        XCTAssertTrue(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
    }
}
