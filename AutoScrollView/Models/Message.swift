//
//  Message.swift
//  FashionBot
//
//  Created by Kenan Begić on 23/09/2020.
//
import Foundation

struct Message : Identifiable {
    
    //MARK: Attributes
    var id: Int
    var message: String
    var message_timestamp: Int
    
    //MARK: Init
    init(id: Int, message: String, message_timestamp: Int){
        self.id = id
        self.message = message
        self.message_timestamp = message_timestamp
    }
}
