//
//  Persistence.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 17/11/2024.
//


import Foundation
import SwiftData

actor Persistence {
    
    enum ErrorType: Error {
        case failedToDeleteExistingData
    }
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    let modelContainer: ModelContainer
    
    @MainActor
    func cacheChats(_ chats: [ChatData]) async throws {
        // For our purposes I'm just dumping all chats and re-inserting them.
        // In practice, our API would return updates-since-timestamp and we would
        // insert-or-update based on that data.
        
        // Note that this has the unfortunate side effect of deleting messages you add
        // in the app yourself if you close and open the app.
        // They are persisted, they're just deleted here.
        try deleteExistingChats()
        let chats = chats.map({ Chat(from: $0, dateFormatter: Self.dateFormatter) })
        for chat in chats {
            modelContainer.mainContext.insert(chat)
        }
        // Chats will now be available in our model container's context in our views.
        do {
            try modelContainer.mainContext.save()
        } catch {
            print("Failed to save chats: \(error)")
        }
    }
    
    @MainActor
    func deleteExistingChats() throws {
        do {
            try modelContainer.mainContext.delete(model: Chat.self)
        }
        catch {
            throw ErrorType.failedToDeleteExistingData
        }
    }
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        // Assuming UTC here since there's no timezone info in the timestamp and
        // not a unix timestamp.
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }
    
}
