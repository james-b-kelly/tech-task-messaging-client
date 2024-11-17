//
//  MessageListView.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 10/11/2024.
//
import SwiftUI
import SwiftData

struct MessageListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var style: Style
    @ObservedObject var viewModel: ChatListViewModel
    @State var newMessageText: String = ""
    @State var lastMessage: Message? = nil
    
    let chat: Chat

    init(chat: Chat, viewModel: ChatListViewModel) {
        self.chat = chat
        self.viewModel = viewModel
    }
    
    var body: some View {
        messageList
    }
    
    var messageList: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollView in
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(chat.orderedMessages) { message in
                            messageRow(message)
                        }
                    }
                    .padding(.bottom, 50)
                    .onAppear {
                        // I've run out of time to get this working but
                        // the idea is of course to scroll to the bottom when
                        // list appears (and also when a new message is added.
                        lastMessage = chat.orderedMessages.last
                        scrollView.scrollTo(lastMessage)
                    }
                }
                .background(style.colors.background2)
            }
            newMessageView()
        }
    }
    
    func messageRow(_ message: Message) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.textForMessage(message))
                .font(style.fonts.body)
                .padding(8)
            HStack {
                Spacer()
                Text(viewModel.timeStringForMessage(message))
                    .font(style.fonts.meta)
                    .foregroundStyle(style.colors.textMeta)
                    .padding(4)
            }
        }
        .background(style.colors.background1)
        .cornerRadius(5)
        .foregroundStyle(style.colors.text)
        .padding(.horizontal, 16)
    }
    
    func newMessageView() -> some View {
        HStack {
            TextEditor(text: $newMessageText)
                .font(style.fonts.title)
                .frame(maxHeight: 80)
                .padding(.horizontal, 8)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .cornerRadius(8)
            Button {
                sendMessage()
            } label: {
                Image(systemName: style.iconNames.plus)
            }
            .buttonStyle(AddMessageButtonStyle())

        }
        .padding(16)
        .background(style.colors.background2)
    }
    
    private func sendMessage() {
        guard newMessageText.isEmpty == false else {
            return
        }
        let message = Message(text: newMessageText)
        withAnimation {
            chat.messages.append(message)
            newMessageText = ""
        }
        try? modelContext.save()
    }
    
}
