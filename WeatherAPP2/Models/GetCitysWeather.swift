import Foundation
import CoreLocation

struct GetCitysWeather {
    let networkWeatherManager = NetworkWeatherManager()
    
    func getCityWeather(citiesArray: [String], complitionHandler: @escaping ([String: WeatherModel]) -> Void) {
        for cityName in citiesArray {
            getCoordinateFrom(city: cityName) { (coordinate, error) in
                guard let coordinate = coordinate, error == nil else { return }
                let lat = coordinate.latitude
                let lon = coordinate.longitude
                
                networkWeatherManager.fetchWeather(lat: lat, lon: lon) { (weather) in
                    let cityWeather: [String: WeatherModel] = [cityName: weather]
                    complitionHandler(cityWeather)
                }
            }
        }
    }
    
    func getCoordinateFrom(city: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> Void) {
        CLGeocoder().geocodeAddressString(city) { (placemark, error) in
            completion(placemark?.first?.location?.coordinate, error)
        }
    }
}
