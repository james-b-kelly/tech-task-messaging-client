//
//  CoreTypes.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 10/11/2024.
//
import Foundation
import SwiftData

// Lighweight structs primarily for decoding chats.
// SwiftData @Model classes for persistence.

struct ChatData: Codable {
    let id: String
    let name: String
    let lastUpdatedString: String
    let messages: [MessageData]
    
    enum CodingKeys: String, CodingKey {
        case id, name, messages
        case lastUpdatedString = "last_updated"
    }
}

struct MessageData: Codable {
    let id: String
    let text: String
    let lastUpdatedString: String
    
    enum CodingKeys: String, CodingKey {
        case id, text
        case lastUpdatedString = "last_updated"
    }
}

@Model
final class Chat: Identifiable {
    var id: String
    var name: String
    var lastUpdated: Date?
    var messages: [Message]
    
    init(from chatData: ChatData, dateFormatter: DateFormatter) {
        self.id = chatData.id
        self.name = chatData.name
        self.lastUpdated = dateFormatter.date(from: chatData.lastUpdatedString)
        self.messages = chatData.messages.map({ Message(from: $0, dateFormatter: dateFormatter) })
    }
    
    var orderedMessages: [Message] {
        return messages.sorted(by: { $0.lastUpdated ?? Date() < $1.lastUpdated ?? Date() })
    }
}

@Model
final class Message: Identifiable {
    var id: String
    var text: String
    var lastUpdated: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, text
        case lastUpdatedString = "last_updated"
    }
    
    init(from messageData: MessageData, dateFormatter: DateFormatter) {
        self.id = messageData.id
        self.text = messageData.text
        self.lastUpdated = dateFormatter.date(from: messageData.lastUpdatedString)
    }

    init(text: String) {
        id = UUID().uuidString
        lastUpdated = Date()
        self.text = text
    }
}
