//
//  AdvanceTodoListUITests.swift
//  AdvanceTodoListUITests
//
//  Created by Leo Kim on 15/10/2021.
//

import XCTest

class AdvanceTodoListUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testExample() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")
    }

    func testOpenAndAddsProjects() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list row initially")

        for tapCount in 1...5 {
            app.buttons["Add Project"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) list row initially")
        }
    }

    func testAddingItemInsertRow() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list row initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row initially")

        app.buttons["Add New Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list row")
    }

    func testClosingProject() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list row initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row initially")

        app.buttons["Compose"].tap()
        app.buttons["Close this project"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list row.")

    }

//    func testEditingProjectUpdatesCorrectly() {
//        app.buttons["Open"].tap()
//        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list row initially.")
//
//        app.buttons["Add Project"].tap()
//        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row initially")
//
//        app.buttons["Compose"].tap()
//        app.textFields["Project name"].tap()
//        app.keys["space"].tap()
//        app.keys["more"].tap()
//        app.keys["2"].tap()
//        app.buttons["Return"].tap()
//
//        app.buttons["Open Projects"].tap()
//        XCTAssertTrue(app.buttons["NEW PROJECT 2"].exists)
//    }

    func testEditingItemUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

        app.buttons["Add New Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding an item.")

        app.buttons["New Item"].tap()

        app.textFields["Item name"].tap()
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()

        XCTAssertTrue(app.buttons["New Item 2"].exists, "The new item name should be visible in the list.")
    }

    func testAllAwardsShowLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists)
        }
    }
}
