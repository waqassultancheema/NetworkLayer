//
//  File.swift
//  
//
//  Created by Waqas Sultan on 22/01/2021.
//

import Foundation

 extension Encodable {
    var toDictonary: [String: Any]? {
        if let data = self.data {
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
            return json
        } else {
            return nil
        }
    }
    
    var data: Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }
}
