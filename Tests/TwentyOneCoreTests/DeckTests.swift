//
//  Created by Ryan Pendleton on 5/25/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

import XCTest
@testable import TwentyOneCore

class DeckTests: XCTestCase {
    static let allTests = [
        ("testCardSorting", testCardSorting),
        ("testHandValues", testHandValues),
    ]

    func testCardSorting() {
        let unsorted = Deck.from("8C 4D 2D 3S AH 2H KC 3C")
        let sorted = unsorted.sorted()

        XCTAssertEqual(sorted, Deck.from("2D 2H 3C 3S 4D 8C KC AH"))
    }

    func testHandValues() {
        XCTAssertEqual([].twentyOneValue, 0)

        XCTAssertEqual(Deck.from("2C").twentyOneValue, 2)
        XCTAssertEqual(Deck.from("3C 3D").twentyOneValue, 6)
        XCTAssertEqual(Deck.from("6C 7D").twentyOneValue, 13)
        XCTAssertEqual(Deck.from("9C 8D 5H").twentyOneValue, 22)
        XCTAssertEqual(Deck.from("JC QD KH").twentyOneValue, 30)
        XCTAssertEqual(Deck.from("TC TD TH TS").twentyOneValue, 40)

        XCTAssertEqual(Deck.from("TD AH").twentyOneValue, 21)
        XCTAssertEqual(Deck.from("TD AH 2H 3H 4H").twentyOneValue, 20)
    }
}
