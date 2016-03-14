//: Playground - noun: a place where people can play

import UIKit

class UserAuthorization {
    var user: String?
    var authenticated: Bool = false
    
    private init() {
        
    }
    
    func authenticate(user: String, pass: String) {
        if (pass == "secret") {
            self.user = user
            self.authenticated = true
        } else {
            self.user = nil
            self.authenticated = false
        }
    }
    
    class var sharedInstance: UserAuthorization {
        get {
            struct singletonWrapper {
                static let singleton = UserAuthorization()
            }
            
            return singletonWrapper.singleton
        }
    }
}

protocol HttpHeaderRequest {
    init(url: String)
    func getHeader(header: String, callback:(String, String?) -> Void)
    func execute()
}

class AccessControlProxy: HttpHeaderRequest {
    private let wrappedObject: HttpHeaderRequest
    
    required init(url: String) {
        wrappedObject = HttpHeaderRequestProxy(url: url)
    }
    
    func getHeader(header: String, callback: (String, String?) -> Void) {
        wrappedObject.getHeader(header, callback: callback)
    }
    
    func execute() {
        if (UserAuthorization.sharedInstance.authenticated) {
            wrappedObject.execute()
        } else {
            fatalError("Unauthorized")
        }
    }
}

class HttpHeaderRequestProxy: HttpHeaderRequest {
    let url: String
    var headersRequired:[String: (String, String?) -> Void]
    
    required init(url: String) {
        self.url = url
        self.headersRequired = Dictionary<String, (String, String?) -> Void>()
    }
    
    func getHeader(header: String, callback: (String, String?) -> Void) {
        self.headersRequired[header] = callback
    }
    
    func execute() {
        let nsURL = NSURL(string: url)
        let request = NSURLRequest(URL: nsURL!)
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                let headers = httpResponse.allHeaderFields as! [String: String]
                for (header, callback) in self.headersRequired {
                    callback(header, headers[header])
                }
            }
        }).resume()
    }
}

let url = "http://www.apress.com"
let headers = ["Content-Length", "Content-Encoding"]
let proxy = AccessControlProxy(url: url);
for header in headers {
    proxy.getHeader(header, callback: {header, val in
        if (val != nil) {
            print("\(header): \(val!)");
        } });
}
UserAuthorization.sharedInstance.authenticate("bob", pass: "secret");
proxy.execute();

NSFileHandle.fileHandleWithStandardInput().availableData
