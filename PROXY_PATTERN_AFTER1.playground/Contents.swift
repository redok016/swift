//: Playground - noun: a place where people can play

import UIKit

protocol HttpHeaderRequest {
    
    func getHeader(url: String, header: String) ->String?
    
}

class HttpHeaderRequestProxy: HttpHeaderRequest {
    private let queue = dispatch_queue_create("httpQ", DISPATCH_QUEUE_SERIAL)
    private let semaphore = dispatch_semaphore_create(0)
    private var cachedHeaders = [String:String]()
    
    func getHeader(url: String, header: String) -> String? {
        var headerValue: String?
        dispatch_sync(self.queue, {() in
            if let cachedValue = self.cachedHeaders[header] {
                headerValue = "\(cachedValue) (cached)";
            } else {
                let nsUrl = NSURL(string: url)
                let request = NSURLRequest(URL: nsUrl!)
                NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
                    data, response, error in
                    if let httpResponse = response as? NSHTTPURLResponse {
                        let headers = httpResponse.allHeaderFields as! [String:String]
                        for (name, value) in headers {
                            self.cachedHeaders[name] = value
                        }
                        if let headerValueNS = httpResponse.allHeaderFields[header] as? NSString {
                            headerValue = headerValueNS as String
                        }
                    }
                    dispatch_semaphore_signal(self.semaphore)
                    
                }).resume()
                
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
            }
        })
        return headerValue
    }
}

let url = "http://www.apress.com"
let headers = ["Content-Length", "Content-Encoding"]
let proxy = HttpHeaderRequestProxy()

for header in headers {
    if let val = proxy.getHeader(url, header:header) {
        print("\(header): \(val)")
    }
}
NSFileHandle.fileHandleWithStandardInput().availableData