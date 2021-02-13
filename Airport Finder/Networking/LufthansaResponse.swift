// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let lHResponseBody = try? newJSONDecoder().decode(LHResponseBody.self, from: jsonData)

import Foundation

// MARK: - LHResponseBody
struct LHResponseBody: Codable {
    let nearestAirportResource: LHNearestAirportResource
    
    enum CodingKeys: String, CodingKey {
        case nearestAirportResource = "NearestAirportResource"
    }
}

// MARK: - LHNearestAirportResource
struct LHNearestAirportResource: Codable {
    let airports: LHAirports
    let meta: LHMeta
    
    enum CodingKeys: String, CodingKey {
        case airports = "Airports"
        case meta = "Meta"
    }
}

// MARK: - LHAirports
struct LHAirports: Codable {
    let airport: [LHAirport]
    
    enum CodingKeys: String, CodingKey {
        case airport = "Airport"
    }
}

// MARK: - LHAirport
struct LHAirport: Codable {
    let airportCode: String
    let position: LHPosition
    let cityCode, countryCode, locationType: String
    let names: LHNames
    let distance: LHDistance
    
    enum CodingKeys: String, CodingKey {
        case airportCode = "AirportCode"
        case position = "Position"
        case cityCode = "CityCode"
        case countryCode = "CountryCode"
        case locationType = "LocationType"
        case names = "Names"
        case distance = "Distance"
    }
}

// MARK: - LHDistance
struct LHDistance: Codable {
    let value: Int
    let uom: String
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case uom = "UOM"
    }
}

// MARK: - LHNames
struct LHNames: Codable {
    let name: LHName
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}

// MARK: - LHName
struct LHName: Codable {
    let languageCode, empty: String
    
    enum CodingKeys: String, CodingKey {
        case languageCode = "@LanguageCode"
        case empty = "$"
    }
}

// MARK: - LHPosition
struct LHPosition: Codable {
    let coordinate: LHCoordinate
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "Coordinate"
    }
}

// MARK: - LHCoordinate
struct LHCoordinate: Codable {
    let latitude, longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}

// MARK: - LHMeta
struct LHMeta: Codable {
    let version: String
    let link: [LHLink]
    
    enum CodingKeys: String, CodingKey {
        case version = "@Version"
        case link = "Link"
    }
}

// MARK: - LHLink
struct LHLink: Codable {
    let href: String
    let rel: String
    
    enum CodingKeys: String, CodingKey {
        case href = "@Href"
        case rel = "@Rel"
    }
}
