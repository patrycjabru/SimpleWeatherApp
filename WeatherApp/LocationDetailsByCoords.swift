import UIKit

class LocationDetailsByCoords: Decodable {
    let distance: Int
    let title: String
    let location_type: String
    let woeid: Int
    let latt_long: String
    
    init(distance: Int, title: String, location_type: String, woeid: Int, latt_long: String) {
        self.distance = distance
        self.title = title
        self.location_type = location_type
        self.woeid = woeid
        self.latt_long = latt_long
    }
}
