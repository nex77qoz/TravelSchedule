import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var fromCity: City? = nil
    @Published var toCity: City? = nil
    @Published var fromStation: Station? = nil
    @Published var toStation: Station? = nil
    
    @Published var showCityPicker: Bool = false
    @Published var cityPickerFor: String = ""
    @Published var showStationPicker: Bool = false
    @Published var stationPickerFor: String = ""
    @Published var showFilter: Bool = false
    
    func swapLocations() {
        swap(&fromCity, &toCity)
        swap(&fromStation, &toStation)
    }
    
    var canSearch: Bool {
        return fromCity != nil && toCity != nil && fromStation != nil && toStation != nil
    }
}
