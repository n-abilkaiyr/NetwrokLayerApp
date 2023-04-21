//
//  Assembler.swift
//  NetworkLayerOne
//
//  Created by user on 20.04.2023.
//

import UIKit

final class Assembler {
    static let shared: Assembler = .init()
    private let network = NetworkService()
    
    private init() {}
    
    private func usersModule() -> UIViewController {
        let usersVC = UsersViewController()
        let usersViewModel = UsersViewModel()
        let usersService = UsersService(network: network)
        
        usersVC.output = usersViewModel
        usersViewModel.view = usersVC
        usersViewModel.usersService = usersService
        
        return usersVC
    }
    
    func createUsersNavigationController() -> UIViewController {
        let navController = UINavigationController(rootViewController: usersModule())
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.tintColor = .systemBlue
        return navController
    }
}
