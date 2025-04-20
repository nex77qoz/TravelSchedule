import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let mainArrayAsSet = Set(self)
        let otherArrayAsSet = Set(other)
        return Array(mainArrayAsSet.symmetricDifference(otherArrayAsSet))
    }
}
