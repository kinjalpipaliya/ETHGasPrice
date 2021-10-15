//
//  GasPriceWidgetApp.swift
//  GasPriceWidget
//
//  Created by Kinjal Pipaliya on 28/09/21.
//

import SwiftUI

@main
struct GasPriceWidgetApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(gasData: JSONModel(status: "", message: "", result: GasResult(lastBlock: "", safeGasPrice: "", proposeGasPrice: "", fastGasPrice: "", suggestBaseFee: "", gasUsedRatio: "")), gasTime: TimeModel(status: "", message: "", result: ""))
        }
    }
}
