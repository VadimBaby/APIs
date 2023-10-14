//
//  ChatGPTView.swift
//  APIs
//
//  Created by Вадим Мартыненко on 14.10.2023.
//

import SwiftUI

struct ChatGPTView: View {
    
    @StateObject private var viewModel = ChatGPTViewModel()
    
    @State private var text: String = ""
    
    @State private var showSettingsSheet: Bool = false
    
    @State private var messageIDToScroll: UUID? = nil
    
    @FocusState private var isFocused
    
    private let columns = [GridItem(.flexible(minimum: 10))]
    
    var body: some View {
        VStack(spacing: 0){
            GeometryReader { geometry in
                ScrollView {
                    ScrollViewReader { scrollReader in
                        getMessageView(viewWidth: geometry.size.width)
                            .padding()
                            .onChange(of: messageIDToScroll) { (_, _) in
                                if let messageID = messageIDToScroll {
                                    scrollTo(messageID: messageID, shouldAnimate: true, scrollReader: scrollReader)
                                }
                            }
                            .onAppear{
                                if let messageID = viewModel.messages.last?.id {
                                    scrollTo(messageID: messageID, anchor: .bottom, shouldAnimate: false, scrollReader: scrollReader)
                                }
                            }
                    }
                }
            }
            .padding(.bottom, 5)
            
            toolbarView()
        }
        .padding(.top, 1)
        .navigationTitle("ChatGPT")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showSettingsSheet = true
                }, label: {
                    Image(systemName: "gear")
                        .tint(Color.primary)
                })
            }
        }
        .onDisappear{
            viewModel.cancel()
        }
    }
    
    private func scrollTo(messageID: UUID, anchor: UnitPoint? = nil, shouldAnimate: Bool, scrollReader: ScrollViewProxy) {
        DispatchQueue.main.async {
            withAnimation(shouldAnimate ? Animation.easeIn : nil) {
                scrollReader.scrollTo(messageID, anchor: anchor)
            }
        }
    }
}

extension ChatGPTView {
    private func getMessageView(viewWidth: CGFloat) -> some View {
        LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders], content: {
            let sectionMessages = viewModel.getSectionMessage()
            
            ForEach(sectionMessages.indices, id: \.self) { sectionIndex in
                let messages = sectionMessages[sectionIndex]
                Section {
                    ForEach(messages) { message in
                        let isMyMessage = message.type == .me
                        HStack {
                            ZStack {
                                Text(message.text)
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .background(isMyMessage ? Color.green.opacity(0.9) : Color.black.opacity(0.2))
                                    .clipShape(.rect(cornerRadius: 15))
                                    .textSelection(.enabled)
                            }
                            .frame(width: viewWidth * 0.7, alignment: isMyMessage ? .trailing : .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: isMyMessage ? .trailing : .leading)
                        .id(message.id)
                    }
                } header: {
                    if let firstMessage = messages.first {
                        sectionHeader(firstMessage: firstMessage)
                    }
                }
            }
        })
    }
    
    private func toolbarView() -> some View {
        VStack{
            let height: CGFloat = 37
            
            HStack {
                TextField("Message...", text: $text)
                    .padding(.horizontal, 10)
                    .frame(height: height)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .focused($isFocused)
                
                Button(action: sendMessage, label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(Color.white)
                        .frame(width: height, height: height)
                        .background(
                            Circle()
                                .foregroundStyle(text.isEmpty ? .gray : .blue)
                        )
                })
                .disabled(text.isEmpty)
            }
            .frame(height: height)
        }
        .padding()
        .background(.thickMaterial)
    }
    
    private func sendMessage() {
        let message = viewModel.sendMessage(text: text)
        messageIDToScroll = message.id
        text = ""
    }
}

extension ChatGPTView {
    private func sectionHeader(firstMessage message: MessageModel) -> some View {
        ZStack{
            Text(message.date.descriptiveString(dateStyle: .medium))
                .foregroundStyle(Color.white)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .frame(width: 120)
                .padding(.vertical, 5)
                .background(Capsule().foregroundStyle(Color.blue))
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity )
    }
}

#Preview {
    NavigationStack{
        ChatGPTView()
    }
}
