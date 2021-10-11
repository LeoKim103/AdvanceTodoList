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

        let showClosedProjects: Bool

        private let projectController: NSFetchedResultsController<Project>
        @Published var projects = [Project]()

        init(dataControler: DataController, showClosedProjects: Bool) {
            self.dataController = dataControler
            self.showClosedProjects = showClosedProjects

            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

            projectController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataControler.container.viewContext,
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
    }
}
