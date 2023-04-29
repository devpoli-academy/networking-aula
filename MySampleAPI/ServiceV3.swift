//
//  ServiceV3.swift
//  MySampleAPI
//
//  Created by Rodrigo Policante Martins on 29/04/23.
//

import Foundation

enum Method: String {
    case POST, GET, DELETE, PUT
}

protocol Route {
    var baseURL: URL { get }
    var path: String { get }
    var params: [String: String] { get }
    var method: Method { get }
    var header: [String: String] { get }
    var body: HttpBody? { get }
}

protocol HttpBody {
    func getData() -> Data?
}

struct EncodableBody: HttpBody {

    let encodable: Encodable

    func getData() -> Data? {
        try? JSONEncoder().encode(encodable)
    }
}

class ServiceV3 {

    private let urlSession: URLSession

    init(
        urlSession: URLSession = .shared
    ) {
        self.urlSession = urlSession
    }

    func execute<T: Decodable>(route: Route, type: T.Type = T.self, callback: @escaping (Result<T, Error>) -> Void) {
        switch route.method {
        case .GET:
            get(route: route, callback: callback)
        case .POST:
            post(route: route, callback: callback)
        default:
            break
        }
    }

    // MARK: - Private

    private func get<T: Decodable>(route: Route, callback: @escaping (Result<T, Error>) -> Void){
        var url = route.baseURL
        url.append(path: route.path)
        url.append(queryItems: route.params.map({ (key, value) in
                .init(
                    name: key,
                    value: value
                )
        }))

        var request = URLRequest(url: url)
//        request.addValue("Authorization", forHTTPHeaderField: "Bearer \(token)")
        route.header.forEach { (key, value) in
            request.addValue(key, forHTTPHeaderField: value)
        }

        request.httpMethod = "GET"
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error {
                callback(.failure(error))
                return
            }

            if let data = data {
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        callback(.success(json))
                    }
                } catch (let err) {
                    callback(.failure(err))
                }

            }

        }

        task.resume()
    }

    private func post<T: Decodable>(route: Route, callback: @escaping (Result<T, Error>) -> Void){
        var url = route.baseURL
        url.append(path: route.path)
        url.append(queryItems: route.params.map({ (key, value) in
                .init(
                    name: key,
                    value: value
                )
        }))

        var request = URLRequest(url: url)
        //        request.addValue("Authorization", forHTTPHeaderField: "Bearer \(token)")
        route.header.forEach { (key, value) in
            request.addValue(key, forHTTPHeaderField: value)
        }

        request.httpBody = route.body?.getData()
        request.httpMethod = "POST"
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error {
                callback(.failure(error))
                return
            }

            if let data = data {
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        callback(.success(json))
                    }
                } catch (let err) {
                    callback(.failure(err))
                }

            }

        }

        task.resume()
    }

}
