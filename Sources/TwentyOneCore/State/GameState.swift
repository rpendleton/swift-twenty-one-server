//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

import ReSwift

public struct GameState: Codable, Equatable, StateType {
    private enum CodingKeys: String, CodingKey {
        case dealerCards = "dealer_cards"
        case remainingStack = "remaining_stack"
        case discardStack = "discard_stack"
        case players
        case stage
        case events
    }

    internal(set) public var dealerCards: [Card] = []
    internal(set) public var remainingStack: [Card] = Card.allCards.shuffled()
    internal(set) public var discardStack: [Card] = []

    internal(set) public var players: [PlayerUUID: PlayerState] = [:]
    internal(set) public var stage: Stage = .waitingForReady(players: [])

    internal(set) public var events: [Event] = []

    // MARK: -

    public init() {

    }

    mutating func queue(event: Event) {
        events.append(event)
    }

    mutating func takeCard() -> Card {
        if remainingStack.count == 0 {
            remainingStack = discardStack.shuffled()
            discardStack = []
        }

        return remainingStack.popLast()!
    }

    mutating func dealCards() {
        for uuid in players.keys {
            var player = players[uuid]!
            player.cards = [takeCard(), takeCard()]

            players[uuid] = player
        }

        dealerCards = [takeCard(), takeCard()]
    }
}
