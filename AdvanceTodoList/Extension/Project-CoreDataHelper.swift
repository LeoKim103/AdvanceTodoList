//
//  Project-CoreDataHelper.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import Foundation

extension Project {
    var projectTitle: String {
        title ?? "New Project"
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectItems: [Item] {
        let itemsArray = items?.allObjects as? [Item] ?? []

        return itemsArray.sorted { first, second in

            // Put completed item at the end of the list,
            // Because we care about them less.
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }
            // Put higher priority items before lower priority items
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }
            // Otherwise sort using creation date
            return first.itemCreationDate < second.itemCreationDate
        }
    }

    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }

        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }

    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = ""
        project.closed = true
        project.creationDate = Date()

        return project

    }
}
