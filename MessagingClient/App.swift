//
//  App.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 10/11/2024.
//

import SwiftUI
import SwiftData

/*
 Assumptions/ommisions due to time.:
 - Your simulator/device is set to Light mode (light/dark could be handled by updating the Style object with more time).
 - Data is loaded from bundled json, and overwrites the existing chats on launch. Chats are persisted with SwiftData.
    New chats are persisted, but on launch they will be overridden.  With more time I would implement update-or-insert functionality.
    In a real-world scenario the API would return updates to chats past a certain timestamp, which would be used to update records selectively.
 - Scrolling to the bottom of the message list automatically is not easily (or quickly, rather) implemented - there is an attempt to work around
    it, but I ran out of time before I could get it working properly.
 - Not a lot of time was left for UI tweaks and making it look especially pretty. The Style environment object demonstrates how UI theming
 and consitency of design can be achieved.
 - There is no pull to refresh - only loading on app launch. In a real world scenario you'd also need to implement push notifications to trigger an
 update or some other real-time mechanism to push to device.
 - I'm taking advantage of SwiftData working with SwiftUI so that the UI can hook directly into model updates.
    In a real world scenario I'd probably prefer to have my MessageService publish chats and have my view model listen for updates so
    I have more control of when the UI updates from model changes.
 */

@main
struct MessaginClientApp: App {

    init() {
        let api = API()
        sharedModelContainer = Self.createModelContainer()
        let messageService = MessageService(api: api, modelContainer: sharedModelContainer)
        mainViewModel = ChatListViewModel(messageService: messageService)
        self.style = Style()
    }
    
    let sharedModelContainer: ModelContainer
    let mainViewModel: ChatListViewModel
    let style: Style
    
    var body: some Scene {
        WindowGroup {
            ChatListView(viewModel: mainViewModel)
                .environmentObject(style)
        }
        .modelContainer(sharedModelContainer)
    }
    
    static func createModelContainer() -> ModelContainer {
        let schema = Schema([
            Chat.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
}
