//
//  ChatListView.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 10/11/2024.
//

import SwiftUI
import SwiftData


class ChatListViewModel: ObservableObject {
    
    @Published var state: State = .loading
    
    let formatter = ChatFormatter()
    
    enum State {
        case loading
        case ready
        case error(_ error: ErrorType)
    }
    
    func updateState(_ state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
    enum ErrorType: Error {
        case network
        case chatFormatting
        case updatingChatLocally
        
        init(messageServiceError error: MessageService.ErrorType) {
            switch error {
            case .network:
                self = .network
            case .invalidData:
                self = .chatFormatting
            case .persistence:
                self = .updatingChatLocally
            }
        }
        
        var userFacingMessage: String {
            switch self {
            case .network:
            return "Please check your wifi/cellular connection."
            case .chatFormatting, .updatingChatLocally:
                return "There was a problem loading your messages, place try again later."
            }
        }
    }
        
    private let messageService: MessageService
    
    init(messageService: MessageService) {
        self.messageService = messageService
    }
    
    func refresh(in modelContext: ModelContext) {
        Task {
            do {
                updateState(.loading)
                try await self.messageService.refreshChats()
                updateState(.ready)
            }
            catch {
                if let error = error as? MessageService.ErrorType {
                    let error = ErrorType(messageServiceError: error)
                    updateState(.error(error))
                }
            }
        }
    }
    
    func titleForChat(_ chat: Chat) -> String {
        return chat.name
    }
    
    func subtitleForChat(_ chat: Chat) -> String {
        formatter.lastUpdatedString(for: chat)
    }
    
    func textForMessage(_ message: Message) -> String {
        message.text
    }
    
    func timeStringForMessage(_ message: Message) -> String {
        formatter.lastUpdatedString(for: message)
    }
}

struct ChatListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var style: Style
    @ObservedObject var viewModel: ChatListViewModel
    @Query(sort: \Chat.lastUpdated, order: .reverse) private var chats: [Chat]
    
    
    init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingView
            case .ready:
                mainChatList
            case .error(let error):
                errorView(error)
            }
        }
        .onAppear {
            viewModel.refresh(in: modelContext)
        }
    }
    
    var mainChatList: some View {
        NavigationStack {
            List {
                ForEach(chats) { chat in
                    NavigationLink {
                        // Our Chat and Message lists share the same model here, mostly
                        // because I don't want to instantiate a class based model for
                        // each message and I'll need to access shared date formatters etc.
                        MessageListView(chat: chat, viewModel: viewModel)
                    } label: {
                        chatRow(chat)
                    }                }
            }
            .navigationTitle("Chats")
        }
    }
    
    var loadingView: some View {
        VStack {
            // Placeholder for our purposes.
            ProgressView()
        }
        .padding(16)
    }
    
    func errorView(_ error: ChatListViewModel.ErrorType) -> some View {
        VStack {
            Text("Placeholder error view - \(error.userFacingMessage)")
        }
    }
    
    func chatRow(_ chat: Chat) -> some View {
        VStack(alignment: .leading) {
            Text(viewModel.titleForChat(chat))
                .font(style.fonts.title)
            Text(viewModel.subtitleForChat(chat))
                .font(style.fonts.subtitle)
        }
        .foregroundStyle(style.colors.text)
    }
}

//#Preview {
//    let s = MessageService(api: API(), modelContainer: <#T##ModelContainer#>)
//    ChatListView(viewModel: ChatListViewModel(messageService: messageService))
//}
