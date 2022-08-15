import Foundation

struct WeatherData: Codable {
    let geo_object: GeoObject
    let fact: Fact
    let forecasts: [Forecasts]
}

struct GeoObject: Codable {
    let locality: Locality
    let country: Country
}

struct Locality: Codable {
    let name: String?
}

struct Country: Codable {
    let name: String?
}

struct Fact: Codable {
    let temp: Double
    let icon: String
    let condition: String
    let wind_speed: Double
    let pressure_mm: Int
}

struct Forecasts: Codable {
    let parts: Parts
}

struct Parts: Codable {
    let day: Day
}

struct Day: Codable {
    let temp_min: Int?
    let temp_max: Int?
}




