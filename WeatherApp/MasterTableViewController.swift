import UIKit

class MasterTableViewController: UITableViewController, MasteViewControllerDelegate {
    
    @IBOutlet var table: UITableView!
    var cities = [CityRecord]()
    var codes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codes += ["44418", "2459115", "523920"]
        loadCities()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    private func loadCities() {
        let photo = UIImage(named: "SampleWeatherIcon")
        for code in codes {
            getDataFromWeatherApi(code: code, photo: photo!)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CityTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell else {
            fatalError("The dequeued cell is not an instance of CityTableViewCell")
        }

        let city = cities[indexPath.row]
        
        cell.cityName.text = city.name
        cell.cityTemp.text = city.temperature
        cell.weatherIcon.image = city.weatherIcon

        return cell
    }
    
    func getDataFromWeatherApi(code: String, photo: UIImage) {
        let exists = cities.filter{ $0.id == code}
        if !exists.isEmpty {
            return
        }
        let url = URL(string: "https://www.metaweather.com/api/location/"+code+"/")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error == nil && data != nil) {
                do{
                    let dataFromApi = try JSONDecoder().decode(WeatherJson.WeatherProperties.self, from: data!)
                    let city = CityRecord(name: dataFromApi.title, temperature: "\(dataFromApi.consolidatedWeather[0].theTemp)", weatherIcon:photo, id: "\(dataFromApi.woeid)")
                    self.cities += [city]
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    } catch let error{
                    print("err", error)
                }
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! ViewController
                print("setting code "+cities[indexPath.row].id)
                controller.cityCode = cities[indexPath.row].id
            }
        }
        else if segue.identifier == "add" {
            let controller = segue.destination as! SearchNewCityTableViewController
            controller.delegate = self
        }
    }
    
    func doSomethingWithData(data: String) {
        codes += [data]
        loadCities()
    }
}
