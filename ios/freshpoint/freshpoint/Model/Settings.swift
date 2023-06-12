//
//  Settings.swift
//  freshpoint
//
//  Created by Michal Marhan on 12.06.2023.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    static let shared = Settings()

    @AppStorage(Constants.userDefaultsKeys.selectedFridge.rawValue) var selectedFridgeId: Int = 298 {
        didSet {
            objectWillChange.send()
        }
    }
}
