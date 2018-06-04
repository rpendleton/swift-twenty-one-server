//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

public enum ServerAction: Equatable {
    case hitDealer
    case settleBets
}

// MARK: -

extension ServerAction: Codable {
    private enum CodingKeys: String, CodingKey {
        static let hitDealer = "hit_dealer"
        static let settleBets = "settle_bets"

        case action
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let action = try values.decode(String.self, forKey: .action)

        switch action {
        case CodingKeys.hitDealer:
            self = .hitDealer

        case CodingKeys.settleBets:
            self = .settleBets

        default:
            throw GameState.Error.malformedPayload
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .hitDealer:
            try container.encode(CodingKeys.hitDealer, forKey: .action)

        case .settleBets:
            try container.encode(CodingKeys.settleBets, forKey: .action)
        }
    }
}
