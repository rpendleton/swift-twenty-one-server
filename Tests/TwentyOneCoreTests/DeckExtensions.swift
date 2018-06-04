//
//  Created by Ryan Pendleton on 4/1/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

import XCTest
@testable import TwentyOneCore

extension Rank {
    static func from(_ character: Character) -> Rank {
        switch String(character).uppercased() {
        case "2": return Rank.two
        case "3": return Rank.three
        case "4": return Rank.four
        case "5": return Rank.five
        case "6": return Rank.six
        case "7": return Rank.seven
        case "8": return Rank.eight
        case "9": return Rank.nine
        case "T": return Rank.ten
        case "J": return Rank.jack
        case "Q": return Rank.queen
        case "K": return Rank.king
        case "A": return Rank.ace
        default:
            XCTFail("unexpected rank character: \(character)")
            fatalError()
        }
    }
}

extension Suit {
    static let allSuits: [Suit] = [.clubs, .diamonds, .hearts, .spades]

    static func from(_ character: Character) -> Suit {
        switch String(character).uppercased() {
        case "C": return Suit.clubs
        case "D": return Suit.diamonds
        case "H": return Suit.hearts
        case "S": return Suit.spades
        default:
            XCTFail("unexpected suit character: \(character)")
            fatalError()
        }
    }
}

extension Card {
    fileprivate static func from(_ string: inout String) -> Card {
        let rank = Rank.from(string.removeFirst())
        let suit = Suit.from(string.removeFirst())
        return Card(rank: rank, suit: suit)
    }

    static func from(_ string: String) -> Card {
        var remaining = string
        return Card.from(&remaining)
    }
}

struct Deck {
    static func from(_ string: String) -> [Card] {
        var cards: [Card] = []
        var remaining = string.trimmingCharacters(in: .whitespacesAndNewlines)

        while !remaining.isEmpty {
            cards.append(Card.from(&remaining))
            remaining = remaining.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return cards
    }
}
