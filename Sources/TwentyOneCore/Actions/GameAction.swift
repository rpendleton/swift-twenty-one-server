//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

import ReSwift

public enum GameAction: Action, Equatable {
    case playerAction(PlayerAction, uuid: PlayerUUID)
    case serverAction(ServerAction)
}

// MARK: -

extension GameAction: Codable {
    private enum CodingKeys: String, CodingKey {
        case uuid
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        if values.contains(.uuid) {
            let action = try PlayerAction(from: decoder)
            let uuid = try values.decode(PlayerUUID.self, forKey: .uuid)

            self = .playerAction(action, uuid: uuid)
        }
        else {
            self = .serverAction(try ServerAction(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .playerAction(let action, let uuid):
            try action.encode(to: encoder)
            try container.encode(uuid, forKey: .uuid)

        case .serverAction(let action):
            try action.encode(to: encoder)
        }
    }
}
