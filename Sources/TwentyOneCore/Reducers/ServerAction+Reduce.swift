//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

extension GameState {
    mutating func reduce(action: ServerAction) {
        switch action {
        case .hitDealer:
            hitDealer()

        case .settleBets:
            settleBets()
        }
    }
}

private extension GameState {
    mutating func hitDealer() {
        while dealerCards.twentyOneValue < 17 {
            dealerCards.append(takeCard())
        }

        reduce(action: .settleBets)
    }

    mutating func settleBets() {
        let dealerPoints = dealerCards.twentyOneValue
        let dealerBusted = dealerPoints > 21

        for uuid in players.keys {
            var player = players[uuid]!
            let playerPoints = player.cards.twentyOneValue

            if player.busted || (playerPoints < dealerPoints && !dealerBusted) {
                player.tokens -= player.bet
            }
            else if playerPoints > dealerPoints || dealerBusted {
                player.tokens += player.bet
            }

            player.bet = 0
            players[uuid] = player
        }

        stage = .waitingForReady(players: Array(players.keys))
    }
}
