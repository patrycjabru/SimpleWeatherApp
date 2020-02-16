import UIKit
import CoreLocation
import MapKit

class SearchNewCityTableViewController: UITableViewController, CLLocationManagerDelegate {

    @IBOutlet var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var locationManager: CLLocationManager!
    var locationUpdateCounter = 60
    
    weak var delegate: MasteViewControllerDelegate?
    
    var cities: [LocationDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.doSomethingWithData(data: "\(cities[indexPath.row].woeid)")
        self.navigationController?.popViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        if locationUpdateCounter == 60 {
            checkCurrentLocation(location: lastLocation)
        }
        locationUpdateCounter -= 1
        if locationUpdateCounter == 0 {
            locationUpdateCounter = 60
        }
    }
    
    func checkCurrentLocation(location: CLLocation) {
        let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(location.coordinate.latitude),\(location.coordinate.longitude)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error == nil && data != nil) {
                do{
                    let data = try JSONDecoder().decode([LocationDetails].self, from: data!)
                    self.cities = [data[0]]
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
}

extension SearchNewCityTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let input = searchBar.text
        getDataFromWeatherApi(query: input!)
    }
    
    func getDataFromWeatherApi(query: String) {
        print("Looking for weather in \(query)")
        let encodedQuery = query.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://www.metaweather.com/api/location/search/?query="+encodedQuery)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error == nil && data != nil) {
                do{
                    self.cities = try JSONDecoder().decode([LocationDetails].self, from: data!)
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
}

protocol MasteViewControllerDelegate: NSObjectProtocol {
    func doSomethingWithData(data: String)
}
