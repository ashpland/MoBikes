//
//  Networking.swift
//  MoBikesCore
//
//  Created by Andrew on 2021-02-27.
//

import Foundation

public struct SimpleError: LocalizedError {
    public var errorDescription: String?
    
    public init(_ description: String) {
        self.errorDescription = description
    }
}

public struct SmooveAPI {
    private static let apiURL = URL(string: "https://vancouver-ca.smoove.pro/api-public/stations")!
    
    public var getStations: (@escaping (Result<[Station], Error>) -> Void) -> Void = getStations(_:)
    
    // datataskpublisher
    
    private static func getStations(_ completionHandler: @escaping (Result<[Station], Error>) -> Void) {
        let request = URLRequest(url: apiURL)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Station.Group.self, from: data) {
                    completionHandler(.success(decodedResponse.stations))
                    return
                } else {
                    completionHandler(.failure(SimpleError("Decoding response failed")))
                }
            } else {
                completionHandler(.failure(SimpleError("No data returned")))
            }
        }.resume()
    }
}

extension SmooveAPI {
    static let live = SmooveAPI()
    static let mock = SmooveAPI(getStations: { $0(.success(Station.examples)) })
}
