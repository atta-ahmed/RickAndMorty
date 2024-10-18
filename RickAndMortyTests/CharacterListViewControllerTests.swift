//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Atta ElAshmawy on 18/10/2024.
//

import XCTest
@testable import RickAndMorty

class CharacterListViewControllerTests: XCTestCase {

    var viewController: CharacterListViewController!
    var mockViewModel: MockCharacterListViewModel!

    override func setUp() {
        super.setUp()
        mockViewModel = MockCharacterListViewModel()
        viewController = CharacterListViewController(viewModel: mockViewModel)

        viewController.loadViewIfNeeded()
    }

    func testFetchCharacters() {
        mockViewModel.simulateFetchingCharacters()
        
        // Trigger fetch characters
        viewController.fetchCharacters()
        
        // Verify that the table view is reloaded
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), 1)
    }

    func testFilterCharacters() {
        // Simulate fetching characters and filtering by status
        mockViewModel.simulateFetchingCharacters()
        viewController.fetchCharacters()
        
        // Simulate filter action
        let filterButton = UIButton()
        filterButton.setTitle("Alive", for: .normal)
        viewController.didFilterPressed(filterButton)
        
        // Verify that the viewModel was called to filter characters
        XCTAssertTrue(mockViewModel.didFilterCharacters)
    }

    func testPagination() {
        mockViewModel.simulateFetchingCharacters()
        viewController.fetchCharacters()
        
        // Scroll to the bottom
        viewController.scrollViewDidScroll(viewController.tableView)
        
        // Verify that another fetch is triggered
        XCTAssertTrue(mockViewModel.didFetchCharacters)
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }
}
