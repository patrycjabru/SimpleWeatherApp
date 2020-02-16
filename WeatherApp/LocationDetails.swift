import UIKit

class LocationDetails: Decodable {
    var title: String
    var location_type: String
    var woeid: Int
    var latt_long: String
    
    init(title: String, location_type: String, woeid: Int, latt_long: String) {
        self.title = title
        self.location_type = location_type
        self.woeid = woeid
        self.latt_long = latt_long
    }
}
