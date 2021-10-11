//
//  HomeView.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: DataController

    static let tag: String? = "Home"

    var body: some View {
        NavigationView {
            VStack {
                Button("Add data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
