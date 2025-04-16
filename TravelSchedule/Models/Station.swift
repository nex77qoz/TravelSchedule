import Foundation

struct Station: Hashable, Identifiable, Sendable {
    let id = UUID()
    let title: String
    let type: String
    let code: String
    let latitude: Double
    let longitude: Double
}

extension Station {
    static let mockData = [
        Station(title: "Киевский вокзал", type: "mock", code: "mock", latitude: 0, longitude: 0),
        Station(title: "Курский вокзал", type: "mock", code: "mock", latitude: 0, longitude: 0),
        Station(title: "Ярославский вокзал", type: "mock", code: "mock", latitude: 0, longitude: 0),
        Station(title: "Белорусский вокзал", type: "mock", code: "mock", latitude: 0, longitude: 0),
        Station(title: "Савеловский вокзал", type: "mock", code: "mock", latitude: 0, longitude: 0),
        Station(title: "Ленинградский вокзал", type: "mock", code: "mock", latitude: 0, longitude: 0)
    ]
}
