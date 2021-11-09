//
//  HomeViewModel.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 13/10/2021.
//

import Foundation
import CoreData

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        var dataController: DataController

        private let projectController: NSFetchedResultsController<Project>
        private let itemController: NSFetchedResultsController<Item>

        @Published var projects = [Project]()
        @Published var items = [Item]()

        @Published var upNext = ArraySlice<Item>()
        @Published var moreToExplore = ArraySlice<Item>()

        init(dataController: DataController) {
            self.dataController = dataController

            // fetching all open projects
            let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequest.predicate = NSPredicate(format: "closed = false")
            projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]

            projectController = NSFetchedResultsController(
                fetchRequest: projectRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil)

            // fetching 10 item with highest priority
            let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()

            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "project.closed = false")
            itemRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
            itemRequest.fetchLimit = 10

            itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]

            itemController = NSFetchedResultsController(
                fetchRequest: itemRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil)

            super.init()
            projectController.delegate = self
            itemController.delegate = self

            do {
                try projectController.performFetch()
                try itemController.performFetch()
                projects = projectController.fetchedObjects ?? []
                items = itemController.fetchedObjects ?? []

                upNext = items.prefix(3)
                moreToExplore = items.dropFirst(3)
            } catch {
                print("Failed to fetch initial data")
            }
        }

//        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//            if let newItems = controller.fetchedObjects as? [Item] {
//                items = newItems
//
//                upNext = items.prefix(3)
//                moreToExplore = items.dropFirst(3)
//            } else if let newProjects = controller.fetchedObjects as? [Project] {
//                projects = newProjects
//            }
//        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            items = itemController.fetchedObjects ?? []

            upNext = items.prefix(3)
            moreToExplore = items.dropFirst(3)

            projects = projectController.fetchedObjects ?? []
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
    }
}
