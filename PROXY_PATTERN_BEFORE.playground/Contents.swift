//: Playground - noun: a place where people can play

import UIKit

func getHeader(header: String) {
    
    let url = NSURL(string: "http://www.apress.com")
    let request = NSURLRequest(URL: url!)
    NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
        data, response, error in
        if let httpResponse = response as? NSHTTPURLResponse {
            if let headerValue = httpResponse.allHeaderFields[header] as? NSString {
                print("\(header): \(headerValue)")
            }
        }
    }).resume()
}

let headers = ["Content-Length", "Content-Encoding"]
for header in headers {
    getHeader(header)
}

NSFileHandle.fileHandleWithStandardInput().availableData

