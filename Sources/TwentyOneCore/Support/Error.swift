//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

import Foundation

extension GameState {
    public enum Error: LocalizedError {
        case wrongStage
        case incorrectPlayerUUID
        case duplicatePlayerUUID
        case malformedPayload

        case noPlayers
        case notEnoughTokens
    }
}
