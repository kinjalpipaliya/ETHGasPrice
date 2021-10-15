//
//  UIColor+Extension.swift
//  GasPriceWidget
//
//  Created by Kinjal Pipaliya on 12/10/21.
//

import Foundation
import UIKit

enum AssetsColorSet {
    case gray
}

extension UIColor {

    static func appColor(_ name: AssetsColorSet) -> UIColor {
        switch name {
        case .gray:
            return UIColor(named: "AppBackground") ?? UIColor.systemBackground
        }
    }
}
