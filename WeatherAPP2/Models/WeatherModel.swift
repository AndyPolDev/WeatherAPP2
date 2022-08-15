import Foundation

struct WeatherModel {
    var cityName: String?
    var countryName: String?
    
    var temp: Double
    var iconLink: String
    var conditionDescription: String
    var windSpeed: Double
    var pressureMm: Int
    var tempMinDay: Int?
    var tempMaxDay: Int?
    
    
    var tempString: String {
        return String(format: "%.0f", temp)
    }
    
    var windSpeedString: String {
        return String(format: "%.1f", windSpeed)
    }
    
    var conditionDescriptionRus: String {
        switch conditionDescription {
        case "clear":
            return "ясно"
        case "partly-cloudy":
            return "малооблачно"
        case "cloudy":
            return "облачно с прояснениями"
        case "overcast":
            return "пасмурно"
        case "drizzle":
            return "морось"
        case "light-rain":
            return "небольшой дождь"
        case "rain":
            return "дождь"
        case "moderate-rain":
            return "умеренно сильный дождь"
        case "heavy-rain":
            return "сильный дождь"
        case "continuous-heavy-rain":
            return "длительный сильный дождь"
        case "showers":
            return "ливень"
        case "wet-snow":
            return "дождь со снегом"
        case "light-snow":
            return "небольшой снег"
        case "snow":
            return "снег"
        case "snow-showers":
            return "снегопад"
        case "hail":
            return "град"
        case "thunderstorm":
            return "гроза"
        case "thunderstorm-with-rain":
            return "дождь с грозой"
        case "thunderstorm-with-hail":
            return "гроза с градом"
        default:
            return "Не известно"
        }
    }
    
    init?(weatherData: WeatherData) {
        cityName = weatherData.geo_object.locality.name
        countryName = weatherData.geo_object.country.name
        temp = weatherData.fact.temp
        iconLink = weatherData.fact.icon
        conditionDescription = weatherData.fact.condition
        windSpeed = weatherData.fact.wind_speed
        pressureMm = weatherData.fact.pressure_mm
        tempMinDay = weatherData.forecasts.first?.parts.day.temp_min
        tempMaxDay = weatherData.forecasts.first?.parts.day.temp_max
    }

}
