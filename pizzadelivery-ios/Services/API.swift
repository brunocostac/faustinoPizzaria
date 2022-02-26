//
//  WebService.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 28/01/22.
//

import Foundation

protocol Api {
    func fetchMenu(completion: @escaping (Bool, [Menu]) -> Void)
    func sendOrder(completion: @escaping (Bool) -> Void)
}

final class MockApiClient: Api {
    func sendOrder(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func fetchMenu(completion: @escaping (Bool, [Menu]) -> Void) {
        
        let filePath = "menu"
        MockApiClient.loadJsonDataFromFile(filePath, completion: { data in
            if let json = data {
                do {
                    let menuData = try JSONDecoder().decode([Menu].self, from: json)
                    completion(true, menuData)
                } catch _ as NSError {
                    fatalError("Couldn't load data from \(filePath)")
                }
            }
        })
        
    }
    
    private static func loadJsonDataFromFile(_ path: String, completion: (Data?) -> Void) {
        if let fileUrl = Bundle.main.url(forResource: path, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                completion(data as Data)
            } catch (let error) {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
