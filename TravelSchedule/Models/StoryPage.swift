import Foundation

struct StoryPage: Identifiable {
    var id = UUID()
    var imageName: String
    var heading: String
    var details: String
}

extension StoryPage {
    static let title = Array(repeating: "title", count: 7).joined(separator: " ").capitalized
    static let description = Array(repeating: "text", count: 20).joined(separator: " ")

    static let mockData1: [StoryPage] = [
        StoryPage(imageName: "1", heading: title, details: description),
        StoryPage(imageName: "2", heading: title, details: description)
    ]
    static let mockData2: [StoryPage] = [
        StoryPage(imageName: "3", heading: title, details: description),
        StoryPage(imageName: "4", heading: title, details: description)
    ]
    static let mockData3: [StoryPage] = [
        StoryPage(imageName: "5", heading: title, details: description),
        StoryPage(imageName: "6", heading: title, details: description)
    ]
    static let mockData4: [StoryPage] = [
        StoryPage(imageName: "7", heading: title, details: description),
        StoryPage(imageName: "8", heading: title, details: description)
    ]
    static let mockData5: [StoryPage] = [
        StoryPage(imageName: "9", heading: title, details: description),
        StoryPage(imageName: "10", heading: title, details: description)
    ]
    static let mockData6: [StoryPage] = [
        StoryPage(imageName: "11", heading: title, details: description),
        StoryPage(imageName: "12", heading: title, details: description)
    ]
    static let mockData7: [StoryPage] = [
        StoryPage(imageName: "13", heading: title, details: description),
        StoryPage(imageName: "14", heading: title, details: description)
    ]
    static let mockData8: [StoryPage] = [
        StoryPage(imageName: "15", heading: title, details: description),
        StoryPage(imageName: "16", heading: title, details: description)
    ]
    static let mockData9: [StoryPage] = [
        StoryPage(imageName: "17", heading: title, details: description),
        StoryPage(imageName: "18", heading: title, details: description)
    ]
}
