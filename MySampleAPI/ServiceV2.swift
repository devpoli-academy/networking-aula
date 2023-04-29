//
//  ServiceV2.swift
//  MySampleAPI
//
//  Created by Rodrigo Policante Martins on 29/04/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
}

class ServiceManager {

    private let urlSession: URLSession
    private let baseURL: URL

    init(
        base: String,
        urlSession: URLSession = .shared
    ) throws {
        guard let url = URL(string: base) else {
            throw NetworkError.invalidURL
        }
        self.baseURL = url
        self.urlSession = urlSession
    }

    func get<T: Decodable>(path: String, params: [String: String] = [:], type: T.Type = T.self, callback: @escaping (T) -> Void){
        var url = baseURL
        url.append(path: path)
        url.append(queryItems: params.map({ (key, value) in
                .init(
                    name: key,
                    value: value
                )
        }))

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        print(request.url?.absoluteURL)

        let task = urlSession.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        callback(json)
                    }
                } catch (let err) {
                    print(err)
                }

            }

        }

        task.resume()
    }

}
