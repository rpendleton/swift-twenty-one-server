//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

import Foundation

public typealias PlayerUUID = UUID

public struct PlayerState: Codable, Equatable {
    public let uuid: PlayerUUID
    public let name: String

    internal(set) public var tokens: Int = 1000
    internal(set) public var bet: Int = 0
    internal(set) public var cards: [Card] = []

    public var busted: Bool {
        return cards.twentyOneValue > 21
    }

    public init(uuid: PlayerUUID, name: String) {
        self.uuid = uuid
        self.name = name
    }
}
