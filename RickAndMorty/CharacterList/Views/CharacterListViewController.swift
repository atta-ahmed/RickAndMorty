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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var viewModel: CharacterListViewModelProtocol = CharacterListViewModel()
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                print("====isLoading", isLoading)
                loadingIndicator.startAnimating()
            } else {
                print("----isLoading", isLoading)
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Characters"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoadingIndicator()
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
        isLoading = true
     viewModel.fetchCharacters()
    }
      
    
    private func setupViewModel() {
        viewModel.onReciveCharacter = { [weak self] in
            print("-------onReciveCharacter -----")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.isLoading = false
            }
        }
        
        viewModel.onError = { [weak self] (error: NetworkError) in
            print("Error fetching orders:", error)
            DispatchQueue.main.async {
                self?.showErrorAlert(message: error.localizedDescription)
                self?.isLoading = false
            }
        }
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfCharcters ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        if let character = viewModel.character(at: indexPath.row) {
            cell.configure(with: character)
        }

        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = CharacterDetailsViewController()
        detailsVC.character = viewModel.character(at: indexPath.row)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            if !isLoading {
                fetchCharacters()
            }
        }
    }
    
}
