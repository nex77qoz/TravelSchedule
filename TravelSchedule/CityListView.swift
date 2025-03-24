import SwiftUI

struct CityListView: View {
    let onCitySelected: (City) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    
    let cities = [
        City(distance: 0, code: "c1", title: "Москва", popularTitle: nil, shortTitle: nil, lat: 55.7558, lng: 37.6173, type: "city"),
        City(distance: 0, code: "c2", title: "Санкт-Петербург", popularTitle: nil, shortTitle: nil, lat: 59.9343, lng: 30.3351, type: "city"),
        City(distance: 0, code: "c3", title: "Казань", popularTitle: nil, shortTitle: nil, lat: 55.8304, lng: 49.0661, type: "city")
    ]
    
    var filteredCities: [City] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredCities) { city in
                Button {
                    onCitySelected(city)
                } label: {
                    Text(city.title)
                }
            }
            .searchable(text: $searchText)
            .navigationBarTitle("Выбор города", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
        }
    }
}
