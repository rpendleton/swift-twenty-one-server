//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

public enum Stage: Equatable {
    case waitingForReady(players: [PlayerUUID])
    case waitingForBets(players: [PlayerUUID])
    case takingCards(players: [PlayerUUID])
}

// MARK: -

extension Stage: Codable {
    private enum CodingKeys: String, CodingKey {
        static let waitingForReady = "waiting_for_ready"
        static let waitingForBets = "waiting_for_bets"
        static let takingCards = "taking_cards"

        case stage
        case players
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stage = try container.decode(String.self, forKey: .stage)
        let players = try container.decode([PlayerUUID].self, forKey: .players)

        switch stage {
        case CodingKeys.waitingForReady:
            self = .waitingForReady(players: players)

        case CodingKeys.waitingForBets:
            self = .waitingForBets(players: players)

        case CodingKeys.takingCards:
            self = .takingCards(players: players)

        default:
            throw GameState.Error.malformedPayload
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .waitingForReady(let players):
            try container.encode(CodingKeys.waitingForReady, forKey: .stage)
            try container.encode(players, forKey: .players)

        case .waitingForBets(let players):
            try container.encode(CodingKeys.waitingForBets, forKey: .stage)
            try container.encode(players, forKey: .players)

        case .takingCards(let players):
            try container.encode(CodingKeys.takingCards, forKey: .stage)
            try container.encode(players, forKey: .players)
        }
    }
}
