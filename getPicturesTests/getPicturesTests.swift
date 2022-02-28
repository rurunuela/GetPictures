//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Richard Urunuela on 25/02/2022.
//

import XCTest
@testable import  getPictures
class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetImageExample() {
        let expectation =  expectation(description: "Waiting")
        Task {
            let resultat  = await PhotoLoader().loadImagesDecription(query: "voiture", page: 1)
            print(resultat)
            switch resultat {
            case .failure :
                    XCTFail("No way")
            case .success:
                print(" SUCCESS ")
            }
            expectation.fulfill()

        }
        waitForExpectations(timeout: 120)
    }
}
