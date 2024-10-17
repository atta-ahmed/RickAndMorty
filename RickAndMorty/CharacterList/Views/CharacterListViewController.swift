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
    @IBOutlet var filterButtons: [UIButton]!
    
    // Track the currently selected button
    private var selectedFilterButton: UIButton?
    var viewModel: CharacterListViewModelProtocol = CharacterListViewModel()
    var isLoading: Bool = false {
        didSet {
            updateLoadingIndicator()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoadingIndicator()
        fetchCharacters()
        setupViewModel()
        setupFilterButtons()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchCharacters() {
        isLoading = true
        viewModel.fetchCharacters()
    }
    
    private func setupViewModel() {
        viewModel.onReciveCharacter = { [weak self] in
            self?.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            self?.handleError(error)
        }
    }
    
    private func setupFilterButtons() {
        for (index, button) in filterButtons.enumerated() {
            guard index < CharacterStatus.allCases.count else { continue }
            let status = CharacterStatus.allCases[index]
            button.setTitle(status.rawValue, for: .normal)
            styleFilterButton(button)
        }
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }
    
    private func styleFilterButton(_ button: UIButton) {
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.masksToBounds = true
    }
    
    private func updateLoadingIndicator() {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.isLoading = false
        }
    }
    
    private func handleError(_ error: NetworkError) {
        print("Error fetching characters:", error)
        DispatchQueue.main.async {
            self.showErrorAlert(message: error.localizedDescription)
            self.isLoading = false
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Characters"
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func selectButton(_ button: UIButton) {
        print("Selected button: \(button.title(for: .normal) ?? "")") // Debugging
        button.backgroundColor = .lightGray // Change to your desired selected color
        button.titleLabel?.textColor = .white
        button.isUserInteractionEnabled = false // Disable interaction
    }

    private func deselectButton(_ button: UIButton) {
        print("Deselected button: \(button.title(for: .normal) ?? "")") // Debugging
        button.backgroundColor = .clear // Reset to original color
        button.titleLabel?.textColor = .black
        button.isUserInteractionEnabled = true // Enable interaction again
    }
    
    // MARK: - Actions
    
    @IBAction func didFilterPressed(_ sender: UIButton) {
        let filterTitle = sender.title(for: .normal)
        let status = CharacterStatus(rawValue: filterTitle ?? "")
        
        // Deselect the previously selected button
        if let selectedButton = selectedFilterButton {
            deselectButton(selectedButton)
        }
        
        // Set the new selected button
        selectedFilterButton = sender
        selectButton(sender)
        
        viewModel.filterCharacter(by: status) { [weak self] in
            self?.reloadData()
        }
    }
}

// MARK: - Delegate and DataSource

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfCharcters
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
//        let detailsVC = CharacterDetailsViewController()
//        detailsVC.character = viewModel.character(at: indexPath.row)
//        navigationController?.pushViewController(detailsVC, animated: true)
        guard let character = viewModel.character(at: indexPath.row) else { return }
        showCharacterDetail(character: character)
    }
    
    // Call this when a character is selected in the list
    func showCharacterDetail(character: Character) {
        let detailView = CharacterDetailView(character: character)
        let hostingController = UIHostingController(rootView: detailView)
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            // stop pagination if view still loading or in isLoading mode
            if !isLoading, !viewModel.isFiltering {
                fetchCharacters()
            }
        }
    }
    
}
