//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

import Foundation
import ReSwift

extension GameState {
    public static func reducer(action: Action, state: GameState?) -> GameState {
        let state = state ?? GameState()

        guard let action = action as? GameAction else {
            return state
        }

        do {
            var newState = state
            newState.events = []
            try newState.reduce(action: action)
            newState.queue(event: .success(action))
            return newState
        }
        catch {
            var newState = state
            newState.events = []

            switch action {
            case .playerAction(_, let uuid):
                newState.queue(event: .error(error.localizedDescription, uuid))

            case .serverAction:
                newState.queue(event: .error(error.localizedDescription, nil))
            }

            return newState
        }
    }

    public static func createStore() -> Store<GameState> {
        return Store(reducer: GameState.reducer, state: GameState())
    }
}
