//
//  CoreDataController.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer

    /// Initializes a data controller, either in memory (for temporary use such as testing and preventing),
    /// or on permanent storage (for use in regular app runs).
    ///
    /// Defaults to permanent storage
    /// - Parameter inMemory: Whether to store this data in temporary memory or not
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ProjectAndItem")

        // For testing and previewing purposed, we create a temporary
        // in-memory database by writing to /dev/null so our data is
        // destroyed after the app finished running
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    func createSampleData() throws {
        let viewContext = container.viewContext

        for projectCounter in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(projectCounter)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for itemCounter in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project // setting the item belong to a specific project
                item.priority = Int16.random(in: 1...3)
            }
        }
        try viewContext.save()
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError()
        }
        return dataController
    }()

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

}
