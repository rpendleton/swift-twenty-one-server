//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

public enum Event: Equatable {
    case success(GameAction)
    case error(String, PlayerUUID?)
}

// MARK: -

extension Event: Codable {
    private enum CodingKeys: String, CodingKey {
        case error
        case uuid
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.contains(.error) {
            let error = try container.decode(String.self, forKey: .error)
            let uuid = try container.decodeIfPresent(PlayerUUID.self, forKey: .uuid)
            self = .error(error, uuid)
        }
        else {
            self = .success(try GameAction(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .success(let action):
            try action.encode(to: encoder)

        case .error(let error, let uuid):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(error, forKey: .error)
            try container.encode(uuid, forKey: .uuid)
        }
    }
}
