//
//  File.swift
//  
//
//  Created by Waqas Sultan on 23/01/2021.
//

import XCTest

extension XCTestCase {
    
    // MARK: - Helper Methods
    func loadJSONDictionaryFromBundle(withName name: String, extension: String) ->  Dictionary<String,AnyObject> {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: `extension`)
        
        let data = try! Data(contentsOf: url!)
        let jsonResult = try! JSONSerialization.jsonObject(with: data, options: [])
        let jsonDicArray = jsonResult as! Dictionary<String,AnyObject>
        return jsonDicArray
    }
}
extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
                                                                return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}
