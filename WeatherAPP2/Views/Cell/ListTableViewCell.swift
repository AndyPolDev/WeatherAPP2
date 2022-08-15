import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configure(weather: WeatherModel) {
        cityNameLabel.text = weather.cityName ?? "Не известно"
        weatherDescriptionLabel.text = weather.conditionDescriptionRus
        tempLabel.text = weather.tempString
    }
}
