//
//  CharactersViewModelTest.swift
//  marvel-characterTests
//
//  Created by Leyner Castillo on 27/07/21.
//

import XCTest
@testable import marvel_character

class CharactersPresenterTest: XCTestCase {

    var sut: CharactersPresenter!

    override func setUpWithError() throws {
        super.setUp()
        MockURL.removeAllStubs()
        sut = CharactersPresenter()
    }

    override func tearDownWithError() throws {
        super.tearDown()
        MockURL.removeAllStubs()
    }

    // MARK: - Tests
    func testDisplayCharacterListCalled() {
        let spy = CharactersViewControllerSpy()
        sut.viewController = spy

        // Given
        guard let baseURL = Environment.getEnvironmentVariable(name: .baseUrl) else { return }
        let stubURL = baseURL + "/v1/public/characters?apikey=74c029bbc49981b5600f3c880ccc4a2d&hash=83c9eed0685feed0816921e0dc097ea5&ts=globant"
        MockURL.addStub(Stub(method: .get, urlString: stubURL, statusCode: 404, response: .success((path: "characters-error", type: "json"))))

        // When
        let expectation = self.expectation(description: "Wait until the request ends")

        sut.fetchCharacters {

            // Then
            XCTAssertTrue(spy.displayErrorCalled)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error)
        }
    }

    func testDisplayErrorCalled() {
        let spy = CharactersViewControllerSpy()
        sut.viewController = spy

        // Given
        guard let baseURL = Environment.getEnvironmentVariable(name: .baseUrl) else { return }
        let stubURL = baseURL + "/v1/public/characters?apikey=74c029bbc49981b5600f3c880ccc4a2d&hash=83c9eed0685feed0816921e0dc097ea5&ts=globant"
        MockURL.addStub(Stub(method: .get, urlString: stubURL, statusCode: 200, response: .success((path: "characters", type: "json"))))

        // When
        let expectation = self.expectation(description: "Wait until the request ends")

        sut.fetchCharacters {

            // Then
            XCTAssertTrue(spy.displayCharactersListCalled)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error)
        }
    }

    func testFetchCharactersCorrectly() throws {
        // Given
        guard let baseURL = Environment.getEnvironmentVariable(name: .baseUrl) else { return }
        let stubURL = baseURL + "/v1/public/characters?apikey=74c029bbc49981b5600f3c880ccc4a2d&hash=83c9eed0685feed0816921e0dc097ea5&ts=globant"
        MockURL.addStub(Stub(method: .get, urlString: stubURL, statusCode: 200, response: .success((path: "characters", type: "json"))))

        // When
        let expectation = self.expectation(description: "Wait until the request ends")

        sut.fetchCharacters {

            // Then
            XCTAssertEqual(self.sut.characters.count, 6)

            let firstCharacter = self.sut.characters.first
            XCTAssertEqual(firstCharacter?.name, "Iron Man")

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error)
        }
    }
}

class CharactersViewControllerSpy: CharactersViewControllerDelegate {
    var displayErrorCalled = false
    var displayCharactersListCalled = false

    func displayError(message: String) {
        displayErrorCalled = true
    }

    func displayCharactersList() {
        displayCharactersListCalled = true
    }
}
