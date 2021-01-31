//
//  ServiceApi.swift
//
//
//  Created by Waqas Sultan on 22/01/2021.
//

import Foundation

public typealias onCompletion = (Any?, NetworkError?)->()


public protocol WebAPIProtocol {
    var session: URLSession {get set}
    func requestData(apiRequest: APIRequest, completion: @escaping onCompletion)
}

public class ServiceApi: WebAPIProtocol {
    
    static let shared = ServiceApi()
    private let cache = LRUCache<String,Data>(capacity: 3)
    private var task: URLSessionTask?
    public var session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private func getDataFromServer(urlRequest: URLRequest, completion: @escaping onCompletion) -> URLSessionTask? {
        
        guard Reachability.isConnectedToNetwork() else {
            completion(nil, NetworkError.noNetwork)
            return nil
        }
        let task = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            ParserURLResponse.parseURLResponse(response: response, data: data, completion: completion,error: error)
        }
        task.resume()
        return task
    }
    
    public func requestData(apiRequest: APIRequest, completion: @escaping onCompletion){
        
        if let request = apiRequest.makeRequest() {
            let urlString = request.url?.absoluteString ?? ""
            if let response = cache.getValue(for: urlString) {
                completion(response, nil)
            } else {
                task =   getDataFromServer(urlRequest: request) { [unowned self] (data, error) in
                    guard error == nil else {
                        completion(nil,error)
                        return
                    }
                    self.cache.setValue(data as! Data, for: urlString)
                    completion(data,error)
                }
            }
        } else {
            completion(nil,NetworkError.other("No Idea"))
        }
    }
    
    func cancelRequest() {
        self.task?.cancel()
    }
    
    
}
