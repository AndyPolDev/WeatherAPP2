import Foundation

struct NetworkWeatherManager {

    func fetchWeather(lat: Double, lon: Double, completionHandler: @escaping (WeatherModel) -> Void) {
        let urlString = "https://api.weather.yandex.ru/v2/forecast?lat=\(lat)&lon=\(lon)"
        guard let url = URL(string: urlString) else {
            print("Error: can't create URL")
            return
        }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue(apiKey, forHTTPHeaderField: header)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, responce, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let safeData = data {
                if let weather = self.parseJSON(weatherData: safeData) {
                    completionHandler(weather)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            guard let currentWeather = WeatherModel(weatherData: decodedData) else {
                print("Error: Can't decoded data from JSON")
                return nil
            }
            return currentWeather
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
