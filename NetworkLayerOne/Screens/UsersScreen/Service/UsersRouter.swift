//
//  UsersRouter.swift
//  NetworkLayerOne
//
//  Created by user on 21.04.2023.
//

import Foundation

enum UsersRouter: Router {
    case getUsers
    case createUser(name: String)
    case updateUser(id: Int, name: String)
    case deleteUser(id: Int)
   
    var baseUrl: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .getUsers, .createUser:
            return "/users"
        case .updateUser(let id, _), .deleteUser(let id):
            return "/users/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getUsers, .deleteUser:
            return [:]
        case .createUser(let name), .updateUser(_, let name):
            return ["name": name]
        }
    }
}
