//
//  Created by Ryan Pendleton on 5/25/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

public enum Rank: String, Codable, Comparable {
    public static let allCases: [Rank] = [
        .two, .three, .four, .five, .six, .seven, .eight, .nine,
        .ten, .jack, .queen, .king, .ace
    ]

    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case jack = "jack"
    case queen = "queen"
    case king = "king"
    case ace = "ace"

    fileprivate var position: Int {
        switch self {
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .jack: return 11
        case .queen: return 12
        case .king: return 13
        case .ace: return 14
        }
    }

    fileprivate var highValue: Int {
        return self == .ace ? 11 : min(position, 10)
    }

    public static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.position < rhs.position
    }
}

public enum Suit: String, Codable, Comparable {
    public static let allCases: [Suit] = [.clubs, .diamonds, .hearts, .spades]

    case clubs
    case diamonds
    case hearts
    case spades

    fileprivate var position: Int {
        switch self {
        case .clubs: return 0
        case .diamonds: return 1
        case .hearts: return 2
        case .spades: return 3
        }
    }

    public static func < (lhs: Suit, rhs: Suit) -> Bool {
        return lhs.position < rhs.position
    }
}

public struct Card: Codable, Comparable {
    public static let allCards: [Card] = {
        var cards: [Card] = []

        for rank in Rank.allCases {
            for suit in Suit.allCases {
                cards.append(Card(rank: rank, suit: suit))
            }
        }

        return cards
    }()

    public let rank: Rank
    public let suit: Suit

    public init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }

    public static func < (lhs: Card, rhs: Card) -> Bool {
        if lhs.rank < rhs.rank {
            return true
        }

        if lhs.rank == rhs.rank && lhs.suit < rhs.suit {
            return true
        }

        return false
    }
}

public extension Collection where Element == Card {
    /**
     * - Complexity: O(n)
     */
    var twentyOneValue: Int {
        var total = self.map { $0.rank.highValue }.reduce(0, +)
        var aceCount = self.filter { $0.rank == .ace }.count

        while total > 21 && aceCount > 0 {
            total -= 10
            aceCount -= 1
        }

        return total
    }
}
