//
//  MessageFormatter.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 10/11/2024.
//
import Foundation

class ChatFormatter {
    
    lazy var fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    func lastUpdatedString(for chat: Chat) -> String {
        guard let lastUpdated = chat.lastUpdated else {
            return "Unknown date/time"
        }
        return fullDateFormatter.string(from: lastUpdated)
    }
    
    func lastUpdatedString(for message: Message) -> String {
        guard let lastUpdated = message.lastUpdated else {
            return "Unknown date/time"
        }
        return fullDateFormatter.string(from: lastUpdated)
    }
    
}
