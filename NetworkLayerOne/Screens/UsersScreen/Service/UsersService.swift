//
//  UsersService.swift
//  NetworkLayerOne
//
//  Created by user on 21.04.2023.
//

protocol UsersServiceProtocol {
    func getAllUsers(completion: @escaping (Result<[User], NetworkError>) -> Void)
    func addUser(name: String, completion: @escaping (Result<User, NetworkError>) -> Void)
    func updateUser(by id: Int, name: String, completion: @escaping (Result<User, NetworkError>) -> Void)
    func deleteUser(by id: Int, completion: @escaping (Result<User, NetworkError>) -> Void)
}

final class UsersService: UsersServiceProtocol {
   private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    // MARK: - UsersServiceProtocol
    
    func getAllUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        network.execute(with: UsersRouter.getUsers, completion: completion)
    }
    
    func addUser(name: String, completion: @escaping (Result<User, NetworkError>) -> Void) {
        network.execute(with: UsersRouter.createUser(name: name), completion: completion)
    }
    
    func updateUser(by id: Int, name: String, completion: @escaping (Result<User, NetworkError>) -> Void) {
        network.execute(with: UsersRouter.updateUser(id: id, name: name), completion: completion)
    }
    
    func deleteUser(by id: Int, completion: @escaping (Result<User, NetworkError>) -> Void) {
        network.execute(with: UsersRouter.deleteUser(id: id), completion: completion)
    }
}
