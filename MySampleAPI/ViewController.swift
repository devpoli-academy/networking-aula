//
//  ViewController.swift
//  MySampleAPI
//
//  Created by Rodrigo Policante Martins on 29/04/23.
//

import UIKit

class ViewController: UITableViewController {

    var data: [Raca] = []
    private var service: ServiceV3?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.service = ServiceV3()
//        Service().getRaca { [weak self] value in
//            self?.data = value
//            self?.tableView.reloadData()
//        }


//        service?.get(path: "/animais", type: [Animal].self) { value in
//            print("Animal:")
////            print(value)
//            }
//
//        service?.get(path: "/raca", params: ["type": "Persa"], type: Racas.self) { value in
//            print("Raca: Com param")
//            print(value)
//        }
//
//        service?.get(path: "/raca", type: Racas.self) { value in
//            print("Raca: Sem param")
//            print(value)
//        }

        service?.execute(
            route: DevPoliAPI.raca(type: "Persa", nacionalidade: "AlgumaCoisa"),
            type: Racas.self,
            callback: { result in
                switch result {
                case let .success(model):
                    print("sucesso")
                    print(model)
                case let .failure(error):
                    print(error)
                }
            }
        )
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = data[indexPath.row].raca
        return cell
    }

}

