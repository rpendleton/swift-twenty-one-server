//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

import ReSwift

public struct Discord {
    public struct PlayerSelector: Codable, Equatable {
        public let uuid: PlayerUUID
        public let name: String
        public let tokens: Int
        public let bet: Int
        public let cards: [Card?]
        public let busted: Bool

        public init(_ state: PlayerState) {
            self.uuid = state.uuid
            self.name = state.name
            self.tokens = state.tokens
            self.bet = state.bet
            self.cards = state.cards
            self.busted = state.busted
        }
    }

    public struct GameStateSelector: Codable, Equatable, StateType {
        let dealerCards: [Card?]
        let players: [String: PlayerSelector]
        let stage: Stage
        let events: [Event]

        public init(_ state: GameState) {
            if case .waitingForReady = state.stage {
                self.dealerCards = state.dealerCards
            }
            else if state.dealerCards.count > 0 {
                self.dealerCards = [nil] + Array(state.dealerCards[1...])
            }
            else {
                self.dealerCards = state.dealerCards
            }

            self.players = Dictionary(state.players.map { ($0.key.uuidString, PlayerSelector($0.value)) }, uniquingKeysWith: { $1 })
            self.stage = state.stage
            self.events = state.events
        }
    }
}
