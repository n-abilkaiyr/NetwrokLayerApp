//
//  UsersViewModel.swift
//  NetworkLayerOne
//
//  Created by user on 21.04.2023.
//

protocol UsersViewOutput {
    func didLaod()
    func addUser(name: String)
    func updateUser(newName: String, userId: Int, at index: Int)
    func deleteUser(by id: Int, at index: Int)
    func refreshButtonTapped()
}

final class UsersViewModel: UsersViewOutput {
    // MARK: - Properties
    
    weak var view: UsersViewInput?
    var usersService: UsersServiceProtocol?
    
    // MARK: - UserViewOutput
    
    func didLaod() {
        getUsers()
    }
    
    func addUser(name: String) {
        view?.showLoader(isLoading: true)
        usersService?.addUser(name: name, completion: { [weak self] result in
            self?.view?.showLoader(isLoading: false)
            switch result {
            case .success(let user):
                self?.view?.insertNewUser(user: User(id: user.id, name: name))
            case .failure(let error):
                self?.view?.showErrorAlert(message: error.message)
            }
        })
    }
    
    func updateUser(newName: String, userId: Int, at index: Int) {
        view?.showLoader(isLoading: true)
        usersService?.updateUser(by: userId, name: newName) { [weak self] result in
            self?.view?.showLoader(isLoading: false)
            switch result {
            case .success(let user):
                self?.view?.updateUser(at: index, with: User(id: user.id, name: newName))
            case .failure(let error):
                self?.view?.showErrorAlert(message: error.message)
            }
        }
    }
    
    func deleteUser(by id: Int, at index: Int) {
        view?.showLoader(isLoading: true)
        usersService?.deleteUser(by: id) { [weak self] result in
            self?.view?.showLoader(isLoading: false)
            switch result {
            case .success:
                self?.view?.deleteUser(at: index)
            case .failure(let error):
                self?.view?.showErrorAlert(message: error.message)
            }
        }
    }
    
    func refreshButtonTapped() {
        getUsers()
    }
    
    
    // MARK: - Private methods
    
    private func getUsers() {
        view?.showLoader(isLoading: true)
        usersService?.getAllUsers { [weak self] result in
            self?.view?.showLoader(isLoading: false)
            switch result {
            case .success(let users):
                self?.view?.display(users: users)
            case .failure(let error):
                self?.view?.showErrorAlert(message: error.message)
            }
        }
    }
}
