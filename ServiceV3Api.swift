//
//  ServiceV3Api.swift
//  MySampleAPI
//
//  Created by Rodrigo Policante Martins on 29/04/23.
//

import Foundation

enum DevPoliAPI{
    case animais
    case raca(type: String, nacionalidade: String)
}

extension DevPoliAPI: Route {
    var baseURL: URL {
        URL(string: "http://localhost:4001/api")!
    }

    var path: String {
        switch self {
        case .animais:
            return "/animais"
        case .raca:
            return "/raca"
        }
    }

    var params: [String : String] {
        switch self {
        case let .raca(type, nacionalidade):
            return [
                "type": type,
                "nacionalidade": nacionalidade
            ]
        default:
            return [:]
        }
    }

    var method: Method {
        switch self {
        case .raca,
                .animais:
            return .GET
        }
    }

    var header: [String : String] {
        [:]
    }

    var body: HttpBody? {
        switch self {
        case let .raca(type):
            return EncodableBody(encodable: TipoRaca(type: type))
        default:
            return nil
        }
    }


}

struct TipoRaca: Encodable {
    let type: String
}
