//
//  APIRequestManager.swift
//  weLearn
//
//  Created by Victor Zhong on 2/13/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class APIRequestManager {
    
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error during session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    
}


class classSchedule {
    
    static let manager = classSchedule()
    private init() {}
    
    var agenda: [Agenda]?
    
}
