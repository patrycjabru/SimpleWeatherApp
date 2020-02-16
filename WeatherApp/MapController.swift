import UIKit
import MapKit

class MapController: UIViewController {
    var locationLatt: String = ""
    var locationLong: String = ""
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("latt: "+locationLatt)
        print("long: "+locationLong)
        let point = CLLocationCoordinate2D(latitude: Double(locationLatt)!, longitude: Double(locationLong)!)
        map.setCenter(point, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = point
        map.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
