import Foundation

struct Filter: Hashable {
    var isWithTransfers = true
    var isAtNight = true
    var isMorning = true
    var isAfternoon = true
    var isEvening = true
}

extension Filter {
    static let fullSearch = Filter()
}

struct Route: Hashable, Identifiable {
    let id = UUID()
    let date: String
    let departureTime: String
    let arrivalTime: String
    let durationTime: String
    let connectionStation: String
    
    var isDirect: Bool {
        connectionStation.isEmpty
    }
    
    let carrierID: UUID
}

extension Route {
    static let sampleData: [Route] = [
        Route(
            date: "14 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationTime: "20",
            connectionStation: "Костроме",
            carrierID: Carrier.sampleData[0].id
        ),
        Route(
            date: "15 января",
            departureTime: "01:15",
            arrivalTime: "09:00",
            durationTime: "9",
            connectionStation: "",
            carrierID: Carrier.sampleData[1].id
        ),
        Route(
            date: "16 января",
            departureTime: "12:30",
            arrivalTime: "21:00",
            durationTime: "9",
            connectionStation: "",
            carrierID: Carrier.sampleData[2].id
        ),
        Route(
            date: "17 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationTime: "20",
            connectionStation: "Костроме",
            carrierID: Carrier.sampleData[0].id
        ),
        Route(
            date: "17 января",
            departureTime: "18:00",
            arrivalTime: "01:00",
            durationTime: "7",
            connectionStation: "",
            carrierID: Carrier.sampleData[0].id
        )
    ]
}

struct Schedule: Hashable, Identifiable {
    let id = UUID()
    let cities: [City]
    let stations: [Station]
    var destinations: [Destination]
    let routes: [Route]
    let carriers: [Carrier]
}

extension Schedule {
    static let sampleData = Schedule(
        cities: City.sampleData,
        stations: Station.sampleData,
        destinations: Destination.emptyDestination,
        routes: Route.sampleData,
        carriers: Carrier.sampleData
    )
}
