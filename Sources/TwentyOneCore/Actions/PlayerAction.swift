//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

public enum PlayerAction: Equatable {
    case join(name: String)
    case leave

    case ready
    case bet(amount: Int)
    case hit
    case stay
}

// MARK: -

extension PlayerAction: Codable {
    private enum CodingKeys: String, CodingKey {
        static let join = "join"
        static let leave = "leave"
        static let ready = "ready"
        static let bet = "bet"
        static let hit = "hit"
        static let stay = "stay"

        case action
        case name
        case amount
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let action = try values.decode(String.self, forKey: .action)

        switch action {
        case CodingKeys.join:
            self = .join(name: try values.decode(String.self, forKey: .name))

        case CodingKeys.leave:
            self = .leave

        case CodingKeys.ready:
            self = .ready

        case CodingKeys.bet:
            self = .bet(amount: try values.decode(Int.self, forKey: .amount))

        case CodingKeys.hit:
            self = .hit

        case CodingKeys.stay:
            self = .stay

        default:
            throw GameState.Error.malformedPayload
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .join(let name):
            try container.encode(CodingKeys.join, forKey: .action)
            try container.encode(name, forKey: .name)

        case .leave:
            try container.encode(CodingKeys.leave, forKey: .action)

        case .ready:
            try container.encode(CodingKeys.ready, forKey: .action)

        case .bet(let amount):
            try container.encode(CodingKeys.bet, forKey: .action)
            try container.encode(amount, forKey: .amount)

        case .hit:
            try container.encode(CodingKeys.hit, forKey: .action)

        case .stay:
            try container.encode(CodingKeys.stay, forKey: .action)
        }
    }
}
