//
//  ProjectView.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import SwiftUI

struct ProjectView: View {
    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.projects.isEmpty {
                    Text("There is nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    projectList
                }
            }
            .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolBarItem
                sortOrderToolBarItems
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"),
                            message: nil,
                            buttons: [
                                .default(Text("Optimized")) { viewModel.sortOrder = .optimized },
                                .default(Text("Creation Date")) { viewModel.sortOrder = .creationDate },
                                .default(Text("Title")) { viewModel.sortOrder = .title }
                            ]
                )
            }

            SelectSomethingView()
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(dataController: DataController.preview, showClosedProjects: false)
    }
}

extension ProjectView {
    private var addProjectToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        viewModel.addProject()
                    }
                } label: {
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add Project")
                    } else {
                        Label("Add Project", systemImage: "plus")
                    }
                }

            }
        }
    }

    private var sortOrderToolBarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }

        }
    }

    private var projectList: some View {
        List {
            ForEach(viewModel.projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: project)
                    }

                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: project)
                            }
                        } label: {
                            Label("Add New Item", systemImage: "plus")
                        }

                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
