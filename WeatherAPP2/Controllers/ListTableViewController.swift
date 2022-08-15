import UIKit

class ListTableViewController: UITableViewController {
    
    var citiesWeatherData = [String: WeatherModel]()
    var filteredCityNameArray = [String]()
    var cityNameArray = ["Москва", "Тверь", "Оренбург", "Сочи", "Тюмень", "Пермь", "Новосибирск", "Чернушка", "Иркутск", "Петербург", "Магадан", "Владивосток"]
    
    let getCitiesWeather = GetCitysWeather()
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 40
        addCities(cityArray: cityNameArray)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func addCities(cityArray:[String]) {
        self.getCitiesWeather.getCityWeather(citiesArray: cityArray) { (cityWeatherData) in
            let dict = cityWeatherData
            DispatchQueue.main.async {
                self.citiesWeatherData.merge(dict) { (_, new) in new }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        alertAddCity(name: "Add City", placeholder: "Enter a city") { (city) in
            var newCity = [String]()
            newCity.append(city)
            self.addCities(cityArray: newCity)
            self.cityNameArray.append(city)
            
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCityNameArray.count
        }
        return cityNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        if isFiltering {
            let dictKey = filteredCityNameArray[indexPath.row]
            if let weather = citiesWeatherData[dictKey] {
                cell.configure(weather: weather)
            }
        } else {
            let dictKey = cityNameArray[indexPath.row]
            if let weather = citiesWeatherData[dictKey] {
                cell.configure(weather: weather)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, complitionHandler) in
            if self.isFiltering {
                self.filteredCityNameArray.remove(at: indexPath.row)
            } else {
                let dictKey = self.cityNameArray[indexPath.row]
                self.citiesWeatherData.removeValue(forKey: dictKey)
                self.cityNameArray.remove(at: indexPath.row)
            }
            tableView.reloadData()
            print(self.cityNameArray)
            print(self.filteredCityNameArray)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            if isFiltering {
                let key = filteredCityNameArray[indexPath.row]
                let cityWeatherData = citiesWeatherData[key]
                let destinationViewController = segue.destination as! DayWeatherViewController
                destinationViewController.cityWeatherData = cityWeatherData
            } else {
                let key = cityNameArray[indexPath.row]
                let cityWeatherData = citiesWeatherData[key]
                let destinationViewController = segue.destination as! DayWeatherViewController
                destinationViewController.cityWeatherData = cityWeatherData
            }
        }
    }
}

extension ListTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCityNameArray = cityNameArray.filter {
            $0.contains(searchText)
        }
        tableView.reloadData()
    }
}
