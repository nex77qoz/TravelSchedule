import Foundation

struct Filter: Hashable, Sendable {
    var isWithTransfers = true
    var isAtNight = true
    var isAtMorning = true
    var isAtAfternoon = true
    var isAtEvening = true
}

extension Filter {
    static let fullSearch = Filter()
    static let customSearch = Filter(isWithTransfers: false, isAtMorning: false)
}
