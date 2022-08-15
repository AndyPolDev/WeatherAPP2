import UIKit
import SVGKit

class DayWeatherViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var viewForImage: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var minDayTempLabel: UILabel!
    @IBOutlet weak var maxDayTempLabel: UILabel!
    
    var cityWeatherData: WeatherModel?
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshUI()
    }
    
    func refreshUI() {
        
        if let safeCityWeatherData = cityWeatherData {
            cityNameLabel.text = safeCityWeatherData.cityName ?? "Неизвестно"
            weatherDescriptionLabel.text = safeCityWeatherData.conditionDescriptionRus
            tempLabel.text = safeCityWeatherData.tempString
            pressureLabel.text = String(safeCityWeatherData.pressureMm)
            windSpeedLabel.text = safeCityWeatherData.windSpeedString
            if let minTemp = safeCityWeatherData.tempMinDay, let maxTemp = safeCityWeatherData.tempMaxDay {
                minDayTempLabel.text = String(minTemp)
                maxDayTempLabel.text = String(maxTemp)
            }
            
            let linkToSVGImage = URL(string: "https://yastatic.net/weather/i/icons/funky/dark/\(safeCityWeatherData.iconLink).svg")
            imageView.downloadedSVG(from: linkToSVGImage!)
        }
    }
}

extension UIImageView {
    func downloadedSVG(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let receivedicon: SVGKImage = SVGKImage(data: data),
                let image = receivedicon.uiImage
            else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }
        .resume()
    }
}

