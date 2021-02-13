//  QueryService.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 11/02/21.
//  
//

import Foundation

class RapidAPILocator: AirportLocator {
    var interactor: InteractorToAirportLocator!
    
    func searchAirport(from location: Location, inRadius radius: Int) {
        // This API requires distance as miles
        let miles = milesFrom(radius)
        
        let baseURL = "https://forteweb-airportguide-airport-basic-info-v1.p.rapidapi.com/airports_nearby"
        
        guard var urlComponents = URLComponents(string: baseURL) else { fatalError() }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "auth", value: "authairport567"),
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "lng", value: "\(location.longitude)"),
            URLQueryItem(name: "miles", value: "\(miles)")
        ]
        
        guard let url = urlComponents.url else { fatalError() }
        
        let headers = [
            "x-rapidapi-key": Secrets.rapidAPIKey,
            "x-rapidapi-host": Secrets.rapidAPIHost
        ]
        
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers
        
        print(request.url!)
        
        /*
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                // TODO: Handle errors
                fatalError("Error retrieving data: \(error!.localizedDescription)\n\(error)")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                // TODO: Use the data
            }
        })
        
        dataTask.resume()
 */

    }
    
    private func milesFrom(_ km: Int) -> Int {
        let mi = Int((Float(km) / 1.62).rounded())
        return mi
    }
}

struct Location {
    let latitude: Double
    let longitude: Double
    
    static let zero = Location(latitude: 0, longitude: 0)
}
