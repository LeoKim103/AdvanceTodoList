//
//  EditItemView.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import SwiftUI

struct EditItemView: View {
    @EnvironmentObject var dataController: DataController

    let item: Item

    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool

    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }

    var body: some View {
        Form {
            basicSettingSection

            prioritySelectionSection

            markCompletedSection
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: update)
        .onDisappear(perform: dataController.save)
    }

}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
            .environmentObject(DataController())
    }
}

extension EditItemView {
    private var basicSettingSection: some View {
        Section(header: Text("Basic settings")) {
            TextField(NSLocalizedString("Item name", comment: ""), text: $title.onChange(update))
            TextField(NSLocalizedString("Description", comment: ""), text: $detail.onChange(update))
        }
    }

    private var prioritySelectionSection: some View {
        Section(header: Text("Priority")) {
            Picker("Priority", selection: $priority.onChange(update)) {
                Text("Low").tag(1)
                Text("Medium").tag(2)
                Text("High").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    private var markCompletedSection: some View {
        Section {
            Toggle("Mark Completed", isOn: $completed.onChange(update))
        }
    }

    private func update() {
        item.project?.objectWillChange.send()

        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }
}
