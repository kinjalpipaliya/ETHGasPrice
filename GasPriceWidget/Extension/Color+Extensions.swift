//
//  Color+Extensions.swift
//  GasPriceWidget
//
//  Created by Kinjal Pipaliya on 11/10/21.
//

import Foundation
import UIKit

enum AssetsColor {
    case gray
    case green
    case textColor
}

extension UIColor {

    static func appColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .gray:
            return UIColor(named: "AppBackground") ?? UIColor.systemBackground
        case .green:
            return UIColor(named: "AppGreen") ?? UIColor.systemGray2
        case .textColor:
            return UIColor(named: "TextColor") ?? UIColor.lightText
        }
    }
}
