//
//  APIRequest.swift
//  
//
//  Created by Waqas Sultan on 22/01/2021.
//

import Foundation


public enum URLMethod: String {
    case get
    case post
    case delete
    case put
    case patch
}

//Define to create the request for the network
public struct APIRequest {
    
    // MARK: - Private Properties
    private let scheme: String
    private let host: String
    private let path: String
    private let httpMethod : URLMethod
    private let parameters : Encodable?
    
    // MARK: - Init
    
    public init(scheme: String = "https", host: String, path: String, httpMethod: URLMethod = .get, parameters: Encodable? = nil) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.httpMethod = httpMethod
        self.parameters = parameters
    }
}

extension APIRequest {
    // MARK: - Public Methods
    public func makeRequest() -> URLRequest? {
        var urlRequest: URLRequest?
        if httpMethod == .get {
            var components = URLComponents()
            components.scheme = self.scheme
            components.host = self.host
          //  components.path = self.path
            components.queryItems = self.parameters?.toDictonary?.map{ key , value in
                URLQueryItem(name: key, value: "\(value)")
            }
            return components.url.map({ URLRequest(url: $0) })
        } else {
            if let url = URL(string: self.scheme + "//" + self.host + "/" + self.path) {
                urlRequest = URLRequest(url: url)
                urlRequest?.httpMethod = httpMethod.rawValue
                urlRequest?.httpBody = self.parameters?.data
            }
        }
        return urlRequest
    }
}
