//
//  AdvanceTodoListTests.swift
//  AdvanceTodoListTests
//
//  Created by Leo Kim on 15/10/2021.
//
import CoreData
import XCTest
@testable import AdvanceTodoList

/// Custom BaseTestCase subclass automatically creates a DataController before evey test run,
/// so all subsequent tests have access to data storage as needed.
class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
