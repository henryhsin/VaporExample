//
//  Word.swift
//  helloWorld
//
//  Created by 辛忠翰 on 2017/4/8.
//
//

import Foundation
import Vapor
import Fluent

final class Word: Model{
    var id: Node?
    var exists = false
    var word: String
    
    init(word: String) {
        self.id = nil
        self.word = word
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        word = try node.extract("word")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "word": word
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("words"){words in
            words.id()
            words.string("word")
            
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("words")
    }
}



