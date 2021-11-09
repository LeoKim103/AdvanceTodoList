//
//  HomeView.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject var viewModel: ViewModel

    static let tag: String? = "Home"

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects, content: ProjectSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        ItemListView(title: "Up next", items: $viewModel.upNext)
                        ItemListView(title: "More to explore", items: $viewModel.moreToExplore)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
//            .toolbar {
//                Button("Add Data", action: viewModel.addSampleData)
//                Button("Delete All", action: viewModel.dataController.deleteAll)
//            }

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}

//    Button("Add data") {
//        dataController.deleteAll()
//        try? dataController.createSampleData()
//    }
