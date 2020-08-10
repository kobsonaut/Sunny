//
//  HTTPClient.swift
//  Sunny
//
//  Created by Polidea on 13/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation

enum HTTPClientError: Error {
    case wrongURLGiven
    case requestError(Error)
    case networkUnreachable
    case badStatusCode(Int)
    case resourceParsingError(Error)
}

class HTTPClient {

    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()

    private struct StatusCode {
        let code: Int

        var isValid: Bool {
            return code >= 200 && code <= 299
        }
    }

    func performRequest<Resource>(
        for endpoint: GetEndpoint<Resource>,
        completion: @escaping (Result<Resource, HTTPClientError>) -> Void) {
        guard var urlComponents = URLComponents(string: endpoint.path) else {
            completion(.error(.wrongURLGiven))
            return
        }
        urlComponents.queryItems = endpoint.parameters.map { elem in
            let (key, value) = elem
            return URLQueryItem(name: key, value: "\(value)")
        }
        guard let url = urlComponents.url else {
            completion(.error(.wrongURLGiven))
            return
        }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                let result = self.validateResponse(data: data, response: response, error: error)
                switch result {
                case let .success(data):
                    do {
                        let resource = try self.jsonDecoder.decode(Resource.self, from: data)
                        completion(.success(resource))
                    } catch {
                        completion(.error(.resourceParsingError(error)))
                    }
                case let .error(error):
                    completion(.error(error))
                }
            }
        })
        task.resume()
    }

    private func validateResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, HTTPClientError> {
        guard let response = response as? HTTPURLResponse, let data = data else {
            return .error(.networkUnreachable)
        }
        let statusCode = StatusCode(code: response.statusCode)
        guard statusCode.isValid else {
            return .error(.badStatusCode(response.statusCode))
        }
        return .success(data)
    }
}
