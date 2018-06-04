//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

extension GameState {
    mutating func reduce(action: PlayerAction, uuid: PlayerUUID) throws {
        switch action {
        case .join(let name):
            try join(uuid: uuid, name: name)

        case .leave:
            try leave(uuid: uuid)

        case .ready:
            try ready()

        case .bet(let amount):
            try bet(uuid: uuid, amount: amount)

        case .hit:
            try hit(uuid: uuid)

        case .stay:
            try stay(uuid: uuid)
        }
    }
}

private extension GameState {
    // MARK: - player management

    mutating func join(uuid: PlayerUUID, name: String) throws {
        guard case .waitingForReady = stage else {
            throw Error.wrongStage
        }

        guard players[uuid] == nil else {
            throw Error.duplicatePlayerUUID
        }

        players[uuid] = PlayerState(uuid: uuid, name: name)
    }

    mutating func leave(uuid: PlayerUUID) throws {
        guard players.keys.contains(uuid) else {
            throw Error.incorrectPlayerUUID
        }

        players.removeValue(forKey: uuid)

        switch stage {
        case .waitingForBets(let remainingPlayers):
            if remainingPlayers.contains(uuid) {
                stage = .waitingForBets(players: remainingPlayers.filter { $0 != uuid })
                checkForLastBet()
            }

        case .takingCards(let remainingPlayers):
            if remainingPlayers.contains(uuid) {
                stage = .takingCards(players: remainingPlayers.filter { $0 != uuid })
                checkForLastStay()
            }

        default:
            break
        }

        if players.count == 0 {
            stage = .waitingForReady(players: [])
        }
    }

    mutating func ready() throws {
        guard players.count > 0 else {
            throw Error.noPlayers
        }

        guard case .waitingForReady = stage else {
            throw Error.wrongStage
        }

        // TODO: actually wait for all players after ready

        for uuid in players.keys {
            var player = players[uuid]!

            discardStack.append(contentsOf: player.cards)
            player.cards = []

            players[uuid] = player
        }

        discardStack.append(contentsOf: dealerCards)
        dealerCards = []

        stage = .waitingForBets(players: Array(players.keys))
    }

    // MARK: - bet management

    mutating func checkForLastBet() {
        if case .waitingForBets(let remainingPlayers) = stage {
            if remainingPlayers.count == 0 {
                stage = .takingCards(players: Array(players.keys))
                dealCards()
            }
        }
    }

    mutating func bet(uuid: PlayerUUID, amount: Int) throws {
        guard var player = players[uuid] else {
            throw Error.incorrectPlayerUUID
        }

        guard case .waitingForBets(let remainingPlayers) = stage else {
            throw Error.wrongStage
        }

        guard remainingPlayers.contains(uuid) else {
            throw Error.wrongStage
        }

        guard amount <= player.tokens else {
            throw Error.notEnoughTokens
        }

        player.bet = amount
        players[uuid] = player

        stage = .waitingForBets(players: remainingPlayers.filter { $0 != uuid })
        checkForLastBet()
    }

    // MARK: - hit or stay management

    mutating func checkForLastStay() {
        if case .takingCards(let remainingPlayers) = stage {
            if remainingPlayers.count == 0 {
                reduce(action: .hitDealer)
            }
        }
    }

    mutating func hit(uuid: PlayerUUID) throws {
        guard var player = players[uuid] else {
            throw Error.incorrectPlayerUUID
        }

        guard case .takingCards(let remainingPlayers) = stage else {
            throw Error.wrongStage
        }

        guard remainingPlayers.contains(uuid) else {
            throw Error.wrongStage
        }

        player.cards.append(takeCard())
        players[uuid] = player

        if player.cards.twentyOneValue > 21 {
            stage = .takingCards(players: remainingPlayers.filter { $0 != uuid })
            checkForLastStay()
        }
    }

    mutating func stay(uuid: PlayerUUID) throws {
        guard players.keys.contains(uuid) else {
            throw Error.incorrectPlayerUUID
        }

        guard case .takingCards(let remainingPlayers) = stage else {
            throw Error.wrongStage
        }

        guard remainingPlayers.contains(uuid) else {
            throw Error.wrongStage
        }

        stage = .takingCards(players: remainingPlayers.filter { $0 != uuid })
        checkForLastStay()
    }
}
