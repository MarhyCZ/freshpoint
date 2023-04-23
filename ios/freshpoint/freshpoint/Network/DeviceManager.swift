//
//  RegisterDevice.swift
//  freshpoint
//
//  Created by Michal Marhan on 23.04.2023.
//

import Foundation

struct DeviceManager {
    
    func sendDeviceTokenToServer(data deviceToken: Data) {
        let url = URL(string: "http://localhost:8080/api/devices")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = ["deviceToken": deviceToken.hexString]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending device token to server: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error sending device token to server: invalid response")
                return
            }
            print("Device token sent successfully to server.")
        }
        task.resume()
    }

}