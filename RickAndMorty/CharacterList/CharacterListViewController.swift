//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 15/10/2024.
//

import UIKit
import SwiftUI

class CharacterListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: CharacterListViewModelProtocol = CharacterListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchCharacters()
        setupViewModel()
    }
    
    private func setupTableView() {
        print("hello from charactersTable")
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchCharacters() {
     viewModel.fetchCharacters()
    }
      
    
    private func setupViewModel() {
        viewModel.onReciveCharacter = { [weak self] in
            print("-------onReciveCharacter -----", self?.viewModel.character(at: 0))
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] (error: NetworkError) in
            print("Error fetching orders:", error)
            DispatchQueue.main.async {
                // self?.showError(message: "Failed to load orders.")
            }
        }
    }

}

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfCharcters ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell() // Return empty if dequeue fails
        }

        // Get the character from the viewModel and configure the cell
        if let character = viewModel.character(at: indexPath.row) {
            cell.configure(with: character)
        }

        return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0 // Adjust this value to the desired height
    }
    
}
