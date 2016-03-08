//: Playground - noun: a place where people can play

import UIKit

class Message : NSObject, NSCopying {
    var to:String;
    var subject:String;
    init(to:String, subject:String) {
        self.to = to; self.subject = subject;
    }
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Message(to: self.to, subject: self.subject);
    }
}

class DetailMessage : Message {
    var from:String;
    init(to: String, subject: String, from:String) {
        self.from = from;
        super.init(to: to, subject: subject);
    }
    override func copyWithZone(zone: NSZone) -> AnyObject {
        return DetailMessage(to: self.to, subject: self.subject, from: self.from)
    }
}

class MessageLogger {
    var messages:[Message] = [];
    func logMessage(msg:Message) {
        let clonedMessage: Message? = msg.copy() as? Message
        if (clonedMessage != nil) {
            self.messages.append(clonedMessage!)
        }
    }
    func processMessages(callback:Message -> Void) {
        for msg in messages {
            callback(msg);
        }
    }
}

var logger = MessageLogger();
var message = Message(to: "Joe", subject: "Hello");
logger.logMessage(message);
message.to = "Bob";
message.subject = "Free for dinner?";
logger.logMessage(message);
logger.logMessage(DetailMessage(to: "Alice", subject: "Hi!", from: "Joe"));
logger.processMessages({msg -> Void in
    if let detailed = msg as? DetailMessage {
        print("Detailed Message - To: \(detailed.to) From: \(detailed.from)"
            + " Subject: \(detailed.subject)");
    } else {
        print("Message - To: \(msg.to) Subject: \(msg.subject)");
    } });