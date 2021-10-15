//
//  Apicall.swift
//  GasPriceWidget
//
//  Created by Kinjal Pipaliya on 29/09/21.
//

import SwiftUI
import Foundation

struct JSONModel : Codable {
//    var id = UUID()
    var status, message: String
    var result: GasResult
}

struct GasResult: Codable {
    let lastBlock, safeGasPrice, proposeGasPrice, fastGasPrice: String?
    let suggestBaseFee, gasUsedRatio: String

    enum CodingKeys: String, CodingKey {
        case lastBlock = "LastBlock"
        case safeGasPrice = "SafeGasPrice"
        case proposeGasPrice = "ProposeGasPrice"
        case fastGasPrice = "FastGasPrice"
        case suggestBaseFee, gasUsedRatio
    }
}

struct TimeModel: Codable {
    let status, message, result: String
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

class Apicall {
        
    func getData(completion: @escaping (JSONModel) -> ()) {
        let url = "https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=BQ21QV6UQRZIJ2TG5FTAS2W19J2C3RNI7V"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil {
                
                print("getting error:\(err!.localizedDescription)")
                
                return
            }

            do {
                let jsonData = try JSONDecoder().decode(JSONModel.self, from: data!)
                print("My json data:\(jsonData)")
                completion(jsonData)
            }
            catch {
                print("catch calling:\(error.localizedDescription)")
            }
        }.resume()
    }
}

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        .lightContent
    }
}
