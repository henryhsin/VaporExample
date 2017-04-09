//
//  Definition.swift
//  helloWorld
//
//  Created by 辛忠翰 on 2017/4/8.
//
//

import Foundation
import Vapor
import Fluent
final class Definition: Model{
    var id: Node?
    var exists = false
    
    var word_id: String
    var definition: String
    var type: String
    var example: String
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
    }
    
    init(word_id: String, definition: String, type: String, example: String) {
        self.word_id = word_id
        self.definition = definition
        self.type = type
        self.example = example
        self.id = nil
    }
    
    func makeNode(context: Context) throws -> Node {
        <#code#>
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("definitions"){definitions in
            definitions.id()
            definitions.string("definition")
            definitions.string("type")
            definitions.string("example")
            
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("definitions")
    }
}
