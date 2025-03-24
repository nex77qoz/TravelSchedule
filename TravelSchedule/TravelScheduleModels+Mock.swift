import Foundation

extension Station {
    init(code: String, title: String, stationType: String? = nil, popularTitle: String? = nil, shortTitle: String? = nil, transportType: String? = nil, longitude: Double? = nil, latitude: Double? = nil, direction: String? = nil, type: String? = nil) {
        self.code = code
        self.title = title
        self.stationType = stationType
        self.popularTitle = popularTitle
        self.shortTitle = shortTitle
        self.transportType = transportType
        self.longitude = longitude
        self.latitude = latitude
        self.direction = direction
        self.type = type
    }
}

//extension Carrier {
//    init(code: Int, title: String, codes: CarrierCodes? = nil, address: String? = nil, url: String? = nil, email: String? = nil, contacts: String? = nil, phone: String? = nil, logo: String? = nil) {
//        self.code = code
//        self.title = title
//        self.codes = codes
//        self.address = address
//        self.url = url
//        self.email = email
//        self.contacts = contacts
//        self.phone = phone
//        self.logo = logo
//    }
//}
