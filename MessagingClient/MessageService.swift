//
//  MessageService.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 17/11/2024.
//

import Foundation
import SwiftData
import SwiftUI

actor MessageService: ObservableObject {
    
    enum ErrorType: Error {
        case network
        case invalidData
        case persistence
        //..
        
        init(error: API.APIError) {
            // In general only pass MessageService errors down to caller
            // to not expose types further up the chain, unless a global error type.
            switch error {
            case .network:
                self = .network
            }
        }
    }
    
    private let api: API
    private let persistence: Persistence
    
    init(api: API, modelContainer: ModelContainer) {
        self.api = api
        self.persistence = Persistence(modelContainer: modelContainer)
    }

    private var refreshTask: Task<Void, Error>? = nil

    func refreshChats() async throws {
        // Using a task here to prevent multiple refresh updates
        // being put in flight at once from different async contexts.
        if let ongoingTask = refreshTask {
            return try await ongoingTask.value
        }
        let task = Task {
            defer { refreshTask = nil }
            let result = await api.fetchChatJSON()
            try await processChatResult(result)
        }
        refreshTask = task
        return try await task.value
    }
    
    private func processChatResult(_ result: Result<[JSON], API.APIError>) async throws {
        switch result {
        case .success(let json):
            do {
                let chats = try chatStructsFromData(json)
                try await persistence.cacheChats(chats)
            } catch {
                throw ErrorType.invalidData
            }
            
        case .failure(let apiError):
            throw ErrorType(error: apiError)
        }
    }
    
    private func chatStructsFromData(_ json: [JSON]) throws -> [ChatData] {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let chats = try JSONDecoder().decode([ChatData].self, from: data)
            return chats
        }
        catch {
            throw ErrorType.invalidData
        }
    }
    
}
