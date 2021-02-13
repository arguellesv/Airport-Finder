//  LufthansaLocator.swift
//  Airport Finder
//
//  Created by Victor Argüelles on 11/02/21.
//  
//

import Foundation

class LufthansaLocator: AirportLocator {
    var interactor: InteractorToAirportLocator!
    
    // The API base URL
    let baseURL = "https://api.lufthansa.com/v1/references/airports/nearest/"
    
    var airports: [Airport] = [] {
        didSet {
            interactor.didUpdateAirportResults(airports)
        }
    }
    
    private var accessTokenKey = "LHAccessToken"
    private var accessToken: AccessToken? {
        didSet {
            storeAccessToken()
        }
    }
    
    init() {
        // Prepare for searching by setting or refreshing the API Access Token
        getAccessToken()
    }
    
    func searchAirport(from location: Location, inRadius radius: Int) {
        // 1. Configure
        self.airports = []
        
        // Request airports immediately, if the access token already exists and is valid
        getAirports(within: radius, from: location)
    }
    /**
     If the access token does not exist, or has expired, it refreshes it with a new one.
     */
    private func getAccessToken() {
        if accessToken != nil, accessToken!.isValid { return }
        
        // 1. Try to get an access token from UserDefaults
        if let accessToken = getAccessTokenFromStorage() {
            self.accessToken = accessToken
            return
        }
        
        // 2. If non-existing or invalid, get a new one
        let url = URL(string: "https://api.lufthansa.com/v1/oauth/token")!
        let parametersString = "client_id=\(Secrets.LHClientID)&client_secret=\(Secrets.LHClientSecret)&grant_type=client_credentials"
        
        // Create and configure request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parametersString.data(using: .utf8)
        
        // Perform the task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // TODO: Handle error
                print(error)
                return
            }
            
            if let response = (response as? HTTPURLResponse),
               response.statusCode == 200,
               let data = data {
                let decoder = JSONDecoder()
                do {
                    let token = try decoder.decode(LHAccessToken.self, from: data)
                    self.accessToken = AccessToken(accessToken: token.accessToken,
                                                   expiresIn: token.expirationTime)
                } catch {
                    print("**** Error: Could not decode the data: \(error.localizedDescription)\n\(error)")
                }
            }
        }
        
        task.resume()
    }
    
    private func getAccessTokenFromStorage() -> AccessToken? {
        let userDefaults = UserDefaults.standard
        
        guard let data = userDefaults.data(forKey: accessTokenKey) else { return nil }
        
        let decoder = JSONDecoder()
        
        do {
            let token = try decoder.decode(AccessToken.self, from: data)
            
            if token.isValid {
                return token
            }
        } catch {
            print("Error decoding the access token: \(error.localizedDescription)\n\n\(error)")
        }
        
        return nil
    }
    
    private func storeAccessToken() {
        guard let accessToken = self.accessToken,
              accessToken.isValid else { return }
        
        let userDefaults = UserDefaults.standard
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(accessToken)
            userDefaults.set(data, forKey: accessTokenKey)
        } catch {
            print("Error encoding the access token for storage: \(error.localizedDescription)\n\n\(error)")
        }
    }
    
    /**
     Retrieves the list of airports and updates the `airports` property with the results.
     
     - Parameters:
     - radius: Acceptable distance from `location` in km
     - location:  a `Location` object with the user's latitude and longitude
     */
    private func getAirports(within radius: Int, from location: Location) {
        guard let token = accessToken, token.isValid else {
            // TODO: Refresh the access token & wait a bit before re-running this method.
            fatalError("The Access Token is nil or invalid.")
        }
        
        let lat = location.latitude
        let lon = location.longitude
        let lang = "EN" // Supported codes: DE, EN, FR, ES, IT
        
        let url = URL(string: "\(baseURL)\(lat),\(lon)?lang=\(lang)")!
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.interactor.didFailToLocateAirports(with: error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               let data = data {
                let decoder = JSONDecoder()
                print("Here")
                do {
                    let responseBody = try decoder.decode(LHResponseBody.self, from: data)
                    self.prepareAndReturn(airports: responseBody.nearestAirportResource.airports.airport,
                                radius: radius)
                    
                } catch {
                    self.interactor.didFailToLocateAirports(with: error)
                }
            } else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                print("Error retrieving data from API. Status code: \(statusCode)")
            }
        }
        
        task.resume()
    }
    
    /**
     Filters the airports retrieved to only include those within the `radius`, and sends the results to the interactor.
     */
    private func prepareAndReturn(airports: [LHAirport], radius: Int) {
        // Keep the results that fall within the user-selected radius and convert to our Airport type
        print("Found \(airports.count) in total. Filtering to those within a \(radius) km radius.")
        
        let airportsWithinDistance: [Airport] = airports
            .filter { $0.distance.value <= radius && $0.locationType == "Airport" }
            .map {
                return Airport(name: $0.names.name.empty,
                               location: Location(latitude: $0.position.coordinate.latitude,
                                                  longitude: $0.position.coordinate.longitude),
                               airportCode: $0.airportCode,
                               cityCode: $0.cityCode,
                               countryCode: $0.countryCode,
                               distance: $0.distance.value)
            }
        
        self.airports = airportsWithinDistance
    }
}



struct AccessToken: Codable {
    let token: String
    let tokenType: String
    let expirationDate: Date
    
    var isValid: Bool {
        get {
            Date().distance(to: expirationDate) > 0
        }
    }
    
    init(accessToken: String, tokenType: String = "Bearer", expiresIn expirationSeconds: Int) {
        self.token = accessToken
        self.tokenType = tokenType
        self.expirationDate = Date(timeIntervalSinceNow: TimeInterval(expirationSeconds))
    }
}

struct LHAccessToken: Codable {
    let accessToken: String
    let tokenType: String
    let expirationTime: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expirationTime = "expires_in"
    }
}
