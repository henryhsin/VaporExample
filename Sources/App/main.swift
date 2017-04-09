import Vapor
import Foundation
import VaporPostgreSQL

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)



drop.get("hello") { request in
        return "Hello, world!"
}

drop.get("hello","there"){request in
    return try JSON(node:[
        "message":"hello I am here!!"
        ])
    
}

drop.get("beer", Int.self){(request, beer) in
    return try JSON(node:[
        "message": "I want \(beer - 5) beers~~"
        ])
}

drop.post("post") { (request) in
    guard let name = request.data["name"]?.string else{
        throw Abort.badRequest
    }
    return try JSON(node:[
        "message": "Hello \(name)"
        ])
}

drop.get("/name", ":name"){request in
    if let name = request.parameters["name"]?.string{
        return "Hello \(name)"
    }
    return "Error retrieving parameters."
}

drop.get("/"){request in
    return try drop.view.make("view.html")
    
}


drop.get("version") { request in
    return try JSON(node: [
        "version":"1"
    ])
}


drop.get("dbversion"){request in
    if let db = drop.database?.driver as? PostgreSQLDriver{
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    }
    return try JSON(node:["message": "No db connection."])
}


drop.get("word", String.self) { (req, word) in
    let session = URLSession.shared
    let wordUrlString: String = "https://owlbot.info/api/v1/dictionary/\(word)"
    guard let url = URL(string: wordUrlString) else{
        print("Error: cannot create URL")
        return try JSON(node: [
            "error code" : "Error: cannot create URL"
            ])
    }
    let task = session.dataTask(with: url){ (data, response, err) in
        guard err == nil else{
            print("error calling GET on /todos/1")
            print(err!)
            return
        }
        
        guard let responseData = data else{
            print("Error: did not receive data")
            return
        }
        
        let json = try? JSONSerialization.jsonObject(with: responseData, options: [])
        
        guard let jsonArray = json as? [Any] else{
            print("Error: wrong data type")
            return
        }
        
        
        for jsonDict in jsonArray{
            
            if let wordDict = jsonDict as? [String: Any]{
                print("\n \(word) \n")
                let defenition = wordDict["defenition"] as? String ?? "no defenition"
                let example = wordDict["example"] as? String ?? "no example"
                let type = wordDict["type"] as? String ?? "no type"
                print("definition : \(defenition)")
                print("example : \(example)")
                print("type : \(type)")
            }else{
                print("Error: wrong data type")
            }
           
        }
    }
    
    task.resume()
    session.finishTasksAndInvalidate()
    
    return try JSON(node: [
        "new word" : word,
        ])
}

drop.run()
