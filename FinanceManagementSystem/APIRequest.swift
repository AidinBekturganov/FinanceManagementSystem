//
//  APIRequest.swift
//  FinanceManagementSystem
//
//  Created by User on 10/28/20.
//

import Foundation


enum APIError: Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct ResponseCatch: Codable {
    var message: String
}

class APIRequest {
    let resourceURL: URL
    
    init(endpoint: String) {
        let resourceString = "https://fms-neobis.herokuapp.com/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func save(_ messageToSave: IncomeData, completion: @escaping(Result<ResponseCatch, APIError>) -> Void) {
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(messageToSave)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    
                    return
                }
                
                if let data = data {
                    do {
                       let messageData = try JSONDecoder().decode(ResponseCatch.self, from: jsonData)
                        completion(.success(messageData))
 
                    } catch {
                        print("ERROR IN CATCH")
                    }
                }
                
            }
            
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
}
