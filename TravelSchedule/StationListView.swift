import SwiftUI

struct StationListView: View {
    let city: City
    let onStationSelected: (Station) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    
    let stations: [Station] = [
        Station(code: "s1", title: "Главный вокзал", stationType: nil, popularTitle: nil, shortTitle: nil, transportType: nil, longitude: nil, latitude: nil, direction: nil, type: nil),
        Station(code: "s2", title: "Центральный вокзал", stationType: nil, popularTitle: nil, shortTitle: nil, transportType: nil, longitude: nil, latitude: nil, direction: nil, type: nil),
        Station(code: "s3", title: "Западный вокзал", stationType: nil, popularTitle: nil, shortTitle: nil, transportType: nil, longitude: nil, latitude: nil, direction: nil, type: nil),
        Station(code: "s4", title: "Восточный вокзал", stationType: nil, popularTitle: nil, shortTitle: nil, transportType: nil, longitude: nil, latitude: nil, direction: nil, type: nil)
    ]
    
    var filteredStations: [Station] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredStations) { station in
                Button {
                    onStationSelected(station)
                } label: {
                    Text(station.title)
                }
            }
            .searchable(text: $searchText)
            .navigationBarTitle("\(city.title) – Вокзалы", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Назад") {
                        dismiss()
                    }
                }
            }
        }
    }
}
