//
//  AdvanceTodoListApp.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 11/10/2021.
//

import SwiftUI

@main
struct AdvanceTodoListApp: App {
    @StateObject var dataController: DataController

    init() {
        let dataController = DataController()

        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                           perform: save)
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
