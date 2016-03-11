//: Playground - noun: a place where people can play

import UIKit

struct Message {
    let from: String
    let to: String
    let subject: String
}

class Transmitter {
    var nextLink: Transmitter?
    
    required init() {
        
    }
    
    func sendMessage(message: Message) {
        if (self.nextLink != nil) {
            self.nextLink!.sendMessage(message)
        } else {
            print("End of Chain of reached. Message not sent")
        }
    }
    
    class func createChain() -> Transmitter? {
        let transmitterClasses:[Transmitter.Type] = [
            PriorityTransmitter.self,
            LocalTransmitter.self,
            RemoteTransmitter.self
        ]
        var link:Transmitter?
        for tClass in transmitterClasses.reverse() {
            let existingLink = link
            link = tClass.init()
            link?.nextLink = existingLink
        }
        return link
    }
    private class func matchEmailSuffix(message: Message) -> Bool {
        if let index = message.from.rangeOfString("@") {
           return message.to.hasSuffix(message.from[Range<String.Index>(start:index.startIndex, end: message.from.endIndex)])
        }
        return false
    }
}

class LocalTransmitter : Transmitter {
    override func sendMessage(message: Message) {
        if (Transmitter.matchEmailSuffix(message)) {
            print("Message to \(message.to) sent locally")
        } else {
            super.sendMessage(message)
        }
    }
}
class RemoteTransmitter : Transmitter {
    override func sendMessage(message: Message) {
        if (!Transmitter.matchEmailSuffix(message)) {
            print("Message to \(message.to) sent remotely")
        } else {
            super.sendMessage(message)
        }
    }
}

class PriorityTransmitter : Transmitter {
    override func sendMessage(message: Message) {
        if (message.subject.hasPrefix("Priority")) {
            print("Message to \(message.to) sent as priority")
        } else {
            super.sendMessage(message)
        }
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

if let chain = Transmitter.createChain() {
    for msg in messages {
        chain.sendMessage(msg)
    }
}
