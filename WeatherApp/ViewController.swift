import UIKit
import Foundation


class ViewController: UIViewController {

    var data: WeatherJson.WeatherProperties?
    var dateIndex: Int = 0
    
    var cityCode: String = "44418"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromWeatherApi()
    }
    
    func getIconFromWeatherApi(iconCode: String) {
        let url = URL(string: "https://www.metaweather.com/static/img/weather/png/64/"+iconCode+".png")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error == nil && data != nil) {
                print("tes")
                let downloadedImage = UIImage(data: data!)
                DispatchQueue.main.async(){
                    self.icon.image = downloadedImage
                }
            }
        }
        task.resume()
    }
    
    func getDataFromWeatherApi() {
        let url = URL(string: "https://www.metaweather.com/api/location/"+cityCode+"/")!
        print("checking code "+cityCode)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error == nil && data != nil) {
                do{
                    self.data = try JSONDecoder().decode(WeatherJson.WeatherProperties.self, from: data!)
                    self.loadDataOnView()
                } catch let error{
                    print("err", error)
                }
            }
        }
        task.resume()
    }
    
    func loadDataOnView()
    {
        DispatchQueue.main.async(){
            self.conditions.text =  self.data?.consolidatedWeather[self.dateIndex].weatherStateName
            self.maxTemp.text = self.data?.consolidatedWeather[self.dateIndex].maxTemp.description
            self.minTemp.text = self.data?.consolidatedWeather[self.dateIndex].minTemp.description
            self.preasure.text = self.data?.consolidatedWeather[self.dateIndex].airPressure.description
            self.wind.text = self.data?.consolidatedWeather[self.dateIndex].windSpeed.description
            self.rain.text = self.data?.consolidatedWeather[self.dateIndex].humidity.description
            self.date.text = self.data?.consolidatedWeather[self.dateIndex].applicableDate
            self.location.text = self.data?.title
            self.getIconFromWeatherApi(iconCode: (self.data?.consolidatedWeather[self.dateIndex].weatherStateAbbr)!)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let controller = segue.destination as! MapController
            
            let longLattArray = data?.lattLong.components(separatedBy: ",")
            controller.locationLatt = longLattArray![0]
            controller.locationLong = longLattArray![1]
        }
    }
    
    @IBOutlet weak var conditions: UITextField!
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var maxTemp: UITextField!
    @IBOutlet weak var wind: UITextField!
    @IBOutlet weak var rain: UITextField!
    @IBOutlet weak var preasure: UITextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var location: UILabel!
    
    @IBAction func onNext(_ sender: Any) {
        print("next",self.dateIndex)
        if (self.dateIndex < (self.data?.consolidatedWeather.count)! - 2) {
            self.dateIndex = dateIndex + 1
            loadDataOnView()
        }
    }
    
    @IBAction func onPrev(_ sender: Any) {
        print("prev",self.dateIndex)
        if (self.dateIndex > 0) {
            self.dateIndex = dateIndex - 1
            loadDataOnView()
        }
    }
}

