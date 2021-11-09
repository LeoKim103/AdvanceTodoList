//
//  ProjectViewModel.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import Foundation
import CoreData

extension ProjectView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        var sortOrder = Item.SortOrder.optimized
        let showClosedProjects: Bool

        private let projectController: NSFetchedResultsController<Project>
        @Published var projects = [Project]()

        @Published var showingUnlockView = false

        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController = dataController
            self.showClosedProjects = showClosedProjects

            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

            projectController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil)

            super.init()
            projectController.delegate = self

            do {
                try projectController.performFetch()
                projects = projectController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch our projects")
            }
        }

        func addProject() {
            let canCreate = dataController.fullVersionUnlocked || dataController.count(for: Project.fetchRequest()) < 2

            if canCreate {
                let project = Project(context: dataController.container.viewContext)
                project.closed = false
                project.creationDate = Date()
                dataController.save()
            } else {
                showingUnlockView.toggle()
            }
        }

        func addItem(to project: Project) {
            let item = Item(context: dataController.container.viewContext)
            item.priority = 2
            item.completed = false
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }

        func delete(_ offsets: IndexSet, from project: Project) {
            let allItems = project.projectItems(using: sortOrder)
            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }
            dataController.save()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
    }
}
