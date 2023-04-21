//
//  UsersViewController.swift
//  NetworkLayerOne
//
//  Created by user on 20.04.2023.
//

import UIKit

protocol UsersViewInput: AnyObject {
    func display(users: [User])
    func insertNewUser(user: User)
    func updateUser(at index: Int, with user: User)
    func deleteUser(at index: Int)
    func showLoader(isLoading: Bool)
    func showErrorAlert(message: String)
}

enum UsersAlertType {
    case add
    case update(currUser: User, index: Int)
}

final class UsersViewController: UIViewController, UsersViewInput {
    // MARK: - Properties
    
    var output: UsersViewOutput?
    private var users: [User] = []
    private enum Constants {
        static let offset: CGFloat = 16
        static let tableHeight: CGFloat = 60
        static let loaderSize: CGFloat = 32
        static let cellReuseId = "userCell"
    }
    
    // MARK: - UI components
    
    private lazy var userTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.color = .black
        view.stopAnimating()
        return view
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        output?.didLaod()
    }
    
    
    // MARK: - UsersViewInput
    
    func display(users: [User]) {
        self.users = users
        userTableView.reloadData()
    }
    
    func insertNewUser(user: User) {
        self.users.append(user)
        userTableView.insertRows(at: [IndexPath(item: users.count - 1, section: 0)], with: .automatic)
    }
    
    func updateUser(at index: Int, with user: User) {
        self.users[index] = user
        self.userTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
    }
    
    func deleteUser(at index: Int) {
        self.users.remove(at: index)
        userTableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
    }
    
    func showLoader(isLoading: Bool) {
        if isLoading {
            view.alpha = 0.8
            loader.startAnimating()
            return
        }
        view.alpha = 1
        loader.stopAnimating()
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error occurs.",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlert(title: String, for type: UsersAlertType) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                return
            }
            switch type {
            case .add:
                self?.output?.addUser(name: text)
            case let .update(currUser, index):
                self?.output?.updateUser(newName: text, userId: currUser.id!, at: index)
            }
        }
        
        alert.addTextField {
            switch type {
            case .add:
                $0.placeholder = "New user.."
            case .update(let currUser, _):
                $0.text = currUser.name
                $0.placeholder = "Update user.."
            }
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    // MARK: - Private methods
    
    private func setupViews() {
        view.backgroundColor = .white
        [userTableView, loader].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
       
        setupNavigationItem()
        setupConstaints()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Users"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addUserButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(refreshButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            userTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            userTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            userTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loader.heightAnchor.constraint(equalToConstant: Constants.loaderSize),
            loader.widthAnchor.constraint(equalToConstant: Constants.loaderSize)
        ])
    }
    
    @objc private func addUserButtonTapped() {
        showAlert(title: "Add new user", for: .add)
    }
    
    @objc private func refreshButtonTapped() {
        self.users = []
        userTableView.reloadData()
        output?.refreshButtonTapped()
    }
}


// MARK: - UITableViewDataSource

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId) ?? UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        showAlert(title: "Update user", for: .update(currUser: user, index: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let user = self.users[indexPath.row]
            self.output?.deleteUser(by: user.id!, at: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
