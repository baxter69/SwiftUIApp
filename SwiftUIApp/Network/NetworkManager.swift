//
//  NetworkManager.swift
//  SwiftUIApp
//
//  Created by Воротников Владимир on 12.01.2025.
//

import Foundation

enum ErrorList: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

class NetworkManager {
    /// https://newsapi.org/v2/everything?q=tesla&from=2024-12-12&sortBy=publishedAt&apiKey=66bc523156ff45b39fbc97f5e6cabfb5
    func sendRequest(query: String, completion: @escaping (Result<[News], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://newsapi.org/v2/everything")
        urlComponents?.queryItems = [
            URLQueryItem(name: "apiKey", value: "66bc523156ff45b39fbc97f5e6cabfb5"),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "pageSize", value: "9"),
            URLQueryItem(name: "language", value: "ru")
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(ErrorList.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data else {
                completion(.failure(ErrorList.invalidData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response.articles))
            } catch {
                completion(.failure(ErrorList.invalidResponse))
            }
        }.resume()
    }
}
