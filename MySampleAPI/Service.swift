//
//  Service.swift
//  MySampleAPI
//
//  Created by Rodrigo Policante Martins on 29/04/23.
//

import Foundation

struct Animal: Decodable {
    let tipo: String
    let nomeDaRaca: String
    let porte: String
    let nacionalidade: String

    enum CodingKeys: String, CodingKey {
        case tipo
        case nomeDaRaca = "raca"
        case porte
        case nacionalidade
    }
}

// MARK: - Racas
struct Racas: Codable {
    let racas: [Raca]
}

// MARK: - Raca
struct Raca: Codable {
    let raca: String
}


class Service {

    func getAnimais(callback: @escaping ([Animal]) -> Void){
        let session = URLSession.shared
        let url = URL(string: "http://localhost:4001/api/animais")!
        //task = method padrão GET
        session.dataTask(with: url) { data, response, error in
            //data => Objeto (JSON)

            if let data = data {
                do {
                    let json = try JSONDecoder().decode([Animal].self, from: data)
                    DispatchQueue.main.async {
                        callback(json)
                    }
                } catch (let err) {
                    print(err)
                }

            }

        }.resume()
    }

    func getRaca(type: String, nacion, callback: @escaping ([Raca]) -> Void){
        let session = URLSession.shared
        let url = URL(string: "http://localhost:4001/api/raca?type=\(type)")!
        //task = method padrão GET
        session.dataTask(with: url) { data, response, error in
            //data => Objeto (JSON)

            if let data = data {
                do {
                    let json = try JSONDecoder().decode(Racas.self, from: data)
                    DispatchQueue.main.async {
                        callback(json.racas)
                    }
                } catch (let err) {
                    print(err)
                }

            }

        }.resume()
    }

}


/*

 url:

 protocolo: http | https
 base | host | dominio: devpoli.com
 posta: 4001
 prefix: api
 path: [ "animais", "cachorro"]
 query | params: {
    tipo: cachorro
    nacionalidade: canadense
 }

 */

// http://localhost:4001/api/user
// http://localhost:4001/api/profile/categories
// http://localhost:4001/api/restaurant/{{id}}/cardapio
