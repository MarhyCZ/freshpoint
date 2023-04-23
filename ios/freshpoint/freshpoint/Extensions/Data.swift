//
//  Data.swift
//  freshpoint
//
//  Created by Michal Marhan on 23.04.2023.
//

import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
