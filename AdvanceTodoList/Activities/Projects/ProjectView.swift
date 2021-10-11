//
//  ProjectView.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import SwiftUI

struct ProjectView: View {
    @StateObject var viewModel: ViewModel

    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataControler: dataController, showClosedProjects: showClosedProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.projects) { project in
                    Section {
                        ForEach(project.projectItems) { item in
                            ItemRowView(item: item)
                        }
                    } header: {
                        ProjectHeaderView(project: project)
                    }

                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
        }
    }
}

struct ProjectView_Previews: PreviewProvider {

    static var previews: some View {
        ProjectView(dataController: DataController.preview, showClosedProjects: false)
    }
}
