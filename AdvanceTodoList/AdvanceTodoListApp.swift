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
    @StateObject var unlockManager: UnlockManager

    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                .onReceive(
                    // Automatically save when we detect that we are no longer the foreground app
                    // Use this rather than the scene phase API so that we can port to MacOS, where
                    // scene phase won't detect our app losing focus as on macOS
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                           perform: save)
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
