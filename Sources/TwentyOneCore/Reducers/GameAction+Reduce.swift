//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

extension GameState {
    mutating func reduce(action: GameAction) throws {
        switch action {
        case .playerAction(let action, let uuid):
            try reduce(action: action, uuid: uuid)

        case .serverAction(let action):
            reduce(action: action)
        }
    }
}
