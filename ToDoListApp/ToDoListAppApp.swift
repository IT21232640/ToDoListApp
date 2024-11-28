import SwiftUI

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared // Core Data controller

    var body: some Scene {
        WindowGroup {
            HomePageView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
