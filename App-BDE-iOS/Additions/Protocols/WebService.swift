//
//  WebService.swift
//  App-BDE-iOS
//
//  Created by Nicolas Barbosa on 05/01/2021.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

enum WebServiceDataType {
    case JSON
}

protocol WebService: Weakable {
    associatedtype DecodedType: Decodable
    associatedtype ServiceParameters: Encodable;

    var url: URL? { get set };
    var httpMethod: HTTPMethod { get set };
    var headers: [String: String]? { get set };
//    var dataType: WebServiceDataType { get set };
    
    func execute(_ parameters: Encodable) -> AnyPublisher<DecodedType, Error>
}

extension WebService {
    private func encodeBody(parameters: Encodable) throws -> Data {
        let encodable = AnyEncodable(parameters)
        return try JSONEncoder().encode(encodable)
    }
    
    func generateHeaders() -> [String: String] {
        var headersArray = headers ?? [:]
        headersArray["Content-Type"] = "application/json"
        headersArray["no-cache"] = "cache-control"
        
        return headersArray
    }
    
    func call(_ parameters: Encodable) -> AnyPublisher<DecodedType, Error> {
        do {
            guard let url = url else { return AnyPublisher.empty() }
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            request.httpBody = try encodeBody(parameters: parameters)
            
            for (key, value) in generateHeaders() {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .map { $0.data }
                .decode(type: DecodedType.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch let error {
            return AnyPublisher(Fail(error: error))
        }
    }
    
}