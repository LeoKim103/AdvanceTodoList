//
//  Project-CoreDataHelper.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import Foundation
import SwiftUI

extension Project {
    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }

    var projectItemsDefaultSorted: [Item] {
         projectItems.sorted { first, second in

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

    var label: LocalizedStringKey {
        LocalizedStringKey(
            "\(projectTitle), \(projectItems.count) items, \(completionAmount * 100, specifier: "%g")% complete."
        )
    }

    static var example: Project {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = ""
        project.closed = true
        project.creationDate = Date()

        return project
    }

    static let colors = [
        "Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal",
        "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"
    ]

    func projectItems<Value: Comparable>(sortedBy keyPath: KeyPath<Item, Value>) -> [Item] {
        projectItems.sorted {
            $0[keyPath: keyPath] < $1[keyPath: keyPath]
        }
    }

    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .optimized:
            return projectItemsDefaultSorted
        case .creationDate:
            return projectItems(sortedBy: \Item.itemCreationDate)
        case .title:
            return projectItems(sortedBy: \Item.itemTitle)
        }
    }
}
