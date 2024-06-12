//
//  APIService.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/12/24.
//

import Foundation

final class APIService {
    
    func apiRequest<T: Decodable, Router: RouterProtocol>(type: T.Type, router: Router) async throws -> T {
        
        var components = URLComponents(string: router.baseURL)
        
        if let queryItems = router.queryItems {
            components?.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        
        if let headers = router.headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let parameters = router.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(T.self, from: data)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            return result
        } catch {
            throw error
        }
    }
    
}
