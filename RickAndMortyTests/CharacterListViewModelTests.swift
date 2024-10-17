//
//  CharacterListViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Atta ElAshmawy on 17/10/2024.
//

import XCTest
@testable import RickAndMorty


final class CharacterListViewModelTests: XCTestCase {
    
    var viewModel: CharacterListViewModel!
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        mockAPIClient = MockAPIClient()
        viewModel = CharacterListViewModel(apiClient: mockAPIClient)
    }

    func testFetchCharactersSuccess() {
        let mockResponse = CharacterResponse(info: nil, results: dummyCharacters)
        mockAPIClient.dummyData = mockResponse
        
        let expectation = self.expectation(description: "Fetch Characters Success")
        
        viewModel.onReciveCharacter = {
            expectation.fulfill()
        }
        
        viewModel.fetchCharacters()
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(viewModel.countOfCharcters, 3)
        XCTAssertEqual(viewModel.character(at: 0)?.name, "Rick Sanchez")
    }
    
    func testFetchCharactersError() {
        let expectation = self.expectation(description: "Fetch Characters Error")
        mockAPIClient.returnError = true
        
        var didReceiveCharacters = false
        var responseError: NetworkError? = nil
        
        viewModel.onError = { error in
            responseError = error
            expectation.fulfill()
        }
        
        viewModel.fetchCharacters()
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertFalse(didReceiveCharacters)
        XCTAssertEqual(responseError?.localizedDescription, "MockedAPIClient error test")
    }
    
    func testFilterCharactersByStatus() {
        let mockResponse = CharacterResponse(info: nil, results: dummyCharacters)
        let mockAPIClient = MockAPIClient()
        let viewModel = CharacterListViewModel(apiClient: mockAPIClient)
        
        mockAPIClient.dummyData = mockResponse

        viewModel.fetchCharacters()
        
        // Filter by 'alive' status
        let filterExpectation = expectation(description: "Filter Characters by Status")
        let resetFilterExpectation = expectation(description: "Reset Character Filter")

        viewModel.filterCharacter(by: .alive) {
            filterExpectation.fulfill()
        }
        
        wait(for: [filterExpectation], timeout: 1)

        // Verify filtered results
        XCTAssertEqual(viewModel.countOfCharcters, 2)
        XCTAssertEqual(viewModel.character(at: 0)?.name, "Rick Sanchez")
        XCTAssertEqual(viewModel.character(at: 1)?.name, "Morty")
        
        // Reset the filter and verify all characters are shown again
        viewModel.filterCharacter(by: nil) {
            resetFilterExpectation.fulfill()
        }
        wait(for: [resetFilterExpectation], timeout: 1)

        XCTAssertEqual(viewModel.countOfCharcters, 3)
    }
    
    override func tearDown() {
        mockAPIClient = nil
        viewModel = nil
        super.tearDown()
    }

}

// mocked characters
let dummyCharacters = [
    Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", gender: "Male"),
    Character(id: 2, name: "Morty", status: .alive, species: "Human", gender: "Male"),
    Character(id: 3, name: "Birdperson", status: .dead, species: "Bird", gender: "Male")
]
