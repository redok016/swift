//: Playground - noun: a place where people can play

import UIKit

struct Message {
    let from: String
    let to: String
    let subject: String
}

class LocalTransmitter {
    func sendMessage(message: Message) {
        print("Message to \(message.to) sent locally")
    }
}

class RemoteTransmitter {
    func sendMessage(message: Message) {
        print("Message to \(message.to) sent remotely")
    }
}

let messages = [
    Message(from: "bob@example.com", to: "joe@example.com",
        subject: "Free for lunch?"),
    Message(from: "joe@example.com", to: "alice@acme.com",
        subject: "New Contracts"),
    Message(from: "pete@example.com", to: "all@example.com",
        subject: "Priority: All-Hands Meeting"),
]

let localT = LocalTransmitter()
let remoteT = RemoteTransmitter()
for msg in messages {
    if let index = msg.from.rangeOfString("@") {
        if (msg.to.hasSuffix(msg.from[Range<String.Index>(start:
            index.startIndex, end: msg.from.endIndex)])) {
                localT.sendMessage(msg);
        } else {
            remoteT.sendMessage(msg);
        }
    } else {
        print("Error: cannot send message to \(msg.from)");
    }
}
