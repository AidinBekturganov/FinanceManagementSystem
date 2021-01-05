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
    let defaults = UserDefaults()
    
    init(endpoint: String) {
        let resourceString = "https://fms-neobis.herokuapp.com/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    
    func changePassword(_ messageToSave: ChangePassword, completion: @escaping(Result<ResponseCatch, APIError>) -> Void) {
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            let token = defaults.object(forKey:"token") as? String ?? ""
            
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "PUT"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(messageToSave)
            
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    print(" HERE IS IN CREATING HTTP\(response)")
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
    
    func save(_ messageToSave: IncomeData, completion: @escaping(Result<ResponseCatch, APIError>) -> Void) {
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            let token = defaults.object(forKey:"token") as? String ?? ""
            
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(messageToSave)
            
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    print(" HERE IS IN CREATING HTTP\(response)")
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
    
    func saveExchange(_ messageToSave: ExchangeData, completion: @escaping(Result<ResponseCatch, APIError>) -> Void) {
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let token = defaults.object(forKey:"token") as? String ?? ""
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
    
    func saveNewCashAccount(_ messageToSave: CreatCashAccount, completion: @escaping(Result<ResponseCatch, APIError>) -> Void) {
        
        
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(messageToSave)
            let token = defaults.object(forKey:"token") as? String ?? ""
            
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
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
