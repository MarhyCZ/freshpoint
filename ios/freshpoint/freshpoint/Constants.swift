//
//  Constants.swift
//  freshpoint
//
//  Created by Michal Marhan on 11.05.2023.
//

import Foundation

struct Constants {
    
#if DEBUG
    static let baseURL = URL(string: "https://freshpoint.mb.marstad.cz")!
    // static let baseURL = URL(string: "http://localhost:8080")!
#else
    static let baseURL = URL(string: "https://freshpoint.mb.marstad.cz")!
#endif
    enum userDefaultsKeys: String {
        case selectedFridge = "SelectedFridge"
    }
}
