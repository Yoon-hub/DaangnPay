//
//  APIService.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/12/24.
//

import Foundation

protocol APIServiceProtocol {
    func apiRequest<T: Decodable, Router: RouterProtocol>(type: T.Type, router: Router) async throws -> T
}

final class APIService: APIServiceProtocol {
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func apiRequest<T: Decodable, Router: RouterProtocol>(type: T.Type, router: Router) async throws -> T {
        
        var components = URLComponents(string: router.baseURL + router.endPoint)
        
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
        
        logRequest(request, parameters: router.parameters)
        
        do {
            let (data, response) = try await self.urlSession.data(for: request)
            
            logResponse(response, data: data)
            
            let result = try JSONDecoder().decode(T.self, from: data)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            return result
        } catch {
            logError(error)
            throw error
        }
    }
    
    private func logRequest(_ request: URLRequest, parameters: [String: Any]?) {
        print("API Request - URL: \(request.url?.absoluteString ?? "No URL")")
        print("API Request - Method: \(request.httpMethod ?? "No HTTP Method")")
        if let headers = request.allHTTPHeaderFields {
            print("API Request - Headers: \(headers)")
        }
        if let parameters = parameters {
            print("API Request - Parameters: \(parameters)")
        }
    }
    
    private func logResponse(_ response: URLResponse, data: Data) {
        if let httpResponse = response as? HTTPURLResponse {
            print("API Response - Status Code: \(httpResponse.statusCode)")
        }
        print("API Response - Data: \(String(data: data, encoding: .utf8) ?? "No data")")
    }
    
    private func logError(_ error: Error) {
        print("API Error: \(error)")
    }
    
}
