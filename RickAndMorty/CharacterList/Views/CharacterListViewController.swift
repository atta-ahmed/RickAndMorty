//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 15/10/2024.
//

import UIKit
import SwiftUI

class CharacterListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var filterButtons: [UIButton]!
    // Track the currently selected button
    private var selectedFilterButton: UIButton?
    
    // MARK: - Varaibls
    private var viewModel: CharacterListViewModelProtocol
    private var isLoading: Bool = false {
        didSet {
            updateLoadingIndicator()
        }
    }
    
    // MARK: - Initilizer
    init(viewModel: CharacterListViewModelProtocol = CharacterListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
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
    
    // MARK: - Helpers
    func fetchCharacters() {
        isLoading = true
        viewModel.fetchCharacters()
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
        button.backgroundColor = .lightGray
        button.titleLabel?.textColor = .white
        button.isUserInteractionEnabled = false
    }

    private func deselectButton(_ button: UIButton) {
        button.backgroundColor = .clear
        button.titleLabel?.textColor = .black
        button.isUserInteractionEnabled = true
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
        guard let character = viewModel.character(at: indexPath.row) else { return }
        showCharacterDetail(character: character) // navigate to SwiftUI
        // showCharacterDetails(character: character) // navigate to UIKit
    }
    
    // navigate to SwiftUI
    func showCharacterDetail(character: Character) {
        let detailView = CharacterDetailView(character: character)
        let hostingController = UIHostingController(rootView: detailView)
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    // navigate to UIKit
    func showCharacterDetails(character: Character) {
        let detailsVC = CharacterDetailsViewController()
        detailsVC.character = character
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            // stop pagination if view still loading or in isFiltering mode
            if !isLoading, !viewModel.isFiltering {
                fetchCharacters()
            }
        }
    }
    
}
