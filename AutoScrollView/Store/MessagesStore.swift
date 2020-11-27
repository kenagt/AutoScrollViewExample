//
//  MessagesStore.swift
//  AutoScrollView
//
//  Created by Kenan Begić on 27/11/2020.
//

import Foundation
import Combine

class MessagesStore: ObservableObject {
    
    //MARK: Attributes
    var didChange = PassthroughSubject<MessagesStore, Never>()
    @Published var messages: [Message] = [] {
        didSet { self.didChange.send(self) }
    }
    
    //MARK: Init
    init(messages: [Message] = []) {
        self.messages = messages
        fetch()
    }
    
    //MARK: fetch
    func fetch() {
        let message = Message(id: 1, message: "First!", message_timestamp: Int(Date().timeIntervalSince1970))
        self.messages.append(message)
    }
}
