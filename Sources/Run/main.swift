//
//  Created by Ryan Pendleton on 6/3/18.
//  Copyright © 2018 Ryan Pendleton. All rights reserved.
//

import TwentyOneCore
import ReSwift
import WebSocket

let store = GameState.createStore()

struct EchoResponder: HTTPServerResponder {
    func respond(to req: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
        return worker.eventLoop.newSucceededFuture(
            result: HTTPResponse(body: "TwentyOne.Run")
        )
    }
}

class Subscriber: StoreSubscriber {
    var connectedClients: [PlayerUUID: WebSocket] = [:]

    func newState(state: Discord.GameStateSelector) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            let data = try encoder.encode(state)

            guard let string = String(data: data, encoding: .utf8) else {
                throw GameState.Error.malformedPayload
            }

            for client in connectedClients.values {
                client.send(string)
            }
        }
        catch {
            fatalError()
        }
    }
}

let subscriber = Subscriber()

store.subscribe(subscriber) {
    return $0.select { Discord.GameStateSelector($0) }
}

let ws = HTTPServer.webSocketUpgrader(
    shouldUpgrade: { req in [:] },
    onUpgrade: { ws, req in
        let uuid = PlayerUUID()

        subscriber.connectedClients[uuid] = ws

        ws.onText { _, string in
            do {
                guard let data = string.data(using: .utf8) else {
                    throw GameState.Error.malformedPayload
                }

                let action = try JSONDecoder().decode(PlayerAction.self, from: data)
                store.dispatch(GameAction.playerAction(action, uuid: uuid))
            }
            catch {
                print("failed to parse request")
            }
        }

        ws.onCloseCode { _ in
            subscriber.connectedClients.removeValue(forKey: uuid)
            store.dispatch(GameAction.playerAction(.leave, uuid: uuid))
        }
})

let server = try HTTPServer.start(
    hostname: "0.0.0.0",
    port: 8080,
    responder: EchoResponder(),
    upgraders: [ws],
    on: MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
).wait()

var done = false

server.onClose.whenComplete {
    done = true
}

while !done {
    RunLoop.main.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
}
