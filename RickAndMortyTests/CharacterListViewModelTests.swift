//
//  CharacterListViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Atta ElAshmawy, Vodafone on 17/10/2024.
//

import XCTest
@testable import RickAndMorty

final class CharacterListViewModelTests: XCTestCase {
    
    var viewModel: CharacterListViewModel!
    var mockAPIClient: APIClientProtocol!

    override func setUpWithError() throws {
        let request = MockedCharactersRequest()
        mockAPIClient = MockedAPIClient()
        viewModel = CharacterListViewModel(apiClient: mockAPIClient, request: request)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchCharactersSuccess() {
        let expectation = self.expectation(description: "Fetch Characters Fai")
        var didReceiveCharacters = false
        
        viewModel.onReciveCharacter = {
            didReceiveCharacters = true
            expectation.fulfill()
        }
        
        viewModel.fetchCharacters()
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(didReceiveCharacters, "Expected to receive characters")
        XCTAssertEqual(viewModel.countOfCharcters, 1, "Expected 1 character")
        XCTAssertEqual(viewModel.character(at: 0)?.name, "Rick Sanchez" )
    }
    
    func testFetchCharactersError() {
        let expectation = self.expectation(description: "Fetch Characters Fail")
        var didReceiveCharacters = false
        var responseError: NetworkError? = nil
        
        viewModel.onReciveCharacter = {
            didReceiveCharacters = true
            expectation.fulfill()
        }
        
        viewModel.onError = { error in
            didReceiveCharacters = false
            responseError = error
            expectation.fulfill()
        }
        
        (mockAPIClient as? MockedAPIClient)?.returnError = true
        
        viewModel.fetchCharacters()
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertFalse(didReceiveCharacters, "Expected to didn't receive any characters")
        XCTAssertEqual(responseError?.localizedDescription, "MockedAPIClient error test")
    }


}
