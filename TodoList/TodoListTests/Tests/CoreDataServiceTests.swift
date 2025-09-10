//
//  CoreDataServiceTests.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import XCTest
@testable import TodoList

final class CoreDataServiceTests: XCTestCase {

    var coreDataService: MockCoreDataService!

    override func setUp() {
        super.setUp()
        coreDataService = MockCoreDataService()
    }

    override func tearDown() {
        coreDataService = nil
        super.tearDown()
    }

    func testFetchCallsCompletion() {
        let expectation = self.expectation(description: "Feth completion called")
        coreDataService.fetch { todos in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(coreDataService.fetchCalled)
    }

    func testSaveItemCalled() {
        let expectation = self.expectation(description: "save completion called")
        coreDataService.saveItem(title: "test", description: nil, isCompleted: false, uuid: nil) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(coreDataService.saveCalled)
    }

    func testUpdateItemCalled() {
        let expectation = self.expectation(description: "Update completion called")
        coreDataService.updateItem(id: UUID(), title: "test", description: nil, isCompleted: true) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(coreDataService.updateCalled)
    }

    func testDeleteItemCalled() {
        let expectation = self.expectation(description: "Deelete completion called")
        coreDataService.deleteItem(id: UUID()) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(coreDataService.deleteCalled)
    }
}
