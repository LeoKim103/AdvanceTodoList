//
//  PerformanceTests.swift
//  AdvanceTodoListTests
//
//  Created by Leo Kim on 15/10/2021.
//

import XCTest
@testable import AdvanceTodoList

class PerformanceTests: BaseTestCase {
    func testAwardCalculationPerformance() throws {
        // Create a significant amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the award count is constant for each test")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
