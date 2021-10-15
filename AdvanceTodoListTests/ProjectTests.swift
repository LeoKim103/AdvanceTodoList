//
//  ProjectTests.swift
//  AdvanceTodoListTests
//
//  Created by Leo Kim on 15/10/2021.
//
import CoreData
import XCTest
@testable import AdvanceTodoList

class ProjectTests: BaseTestCase {
    func testCreatingProjectAndItem() {
        let targetCount = 10

        for _ in 0..<targetCount {
            let project = Project(context: managedObjectContext)

            for _ in 0..<targetCount {
                let item = Item(context: managedObjectContext)
                item.project = project
            }
        }

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingProjectCascadeDeletesItems() throws {
        try dataController.createSampleData()

        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)

        dataController.delete(projects[0])

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 40)
    }

    func testExampleProjectIsClosed() {
        let project = Project.example

        XCTAssertTrue(project.closed, "The example project should be closed")
    }

    func testExampleItemIsHighPriority() {
        let item = Item.example

        XCTAssertEqual(item.priority, 3, "the example item should be high priority")
    }
}
