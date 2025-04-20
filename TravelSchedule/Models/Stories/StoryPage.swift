import Foundation

struct StoryPage: Identifiable, Sendable {
    var id = UUID()
    var imageName: String
    var title: String
    var description: String
}

extension StoryPage {
    static let title = Array(repeating: "title", count: 7).joined(separator: " ").capitalized
    static let description = Array(repeating: "text", count: 20).joined(separator: " ")

    static let mockData1: [StoryPage] = [
        StoryPage(imageName: "1", title: title, description: description),
        StoryPage(imageName: "2", title: title, description: description)
    ]
    static let mockData2: [StoryPage] = [
        StoryPage(imageName: "3", title: title, description: description),
        StoryPage(imageName: "4", title: title, description: description)
    ]
    static let mockData3: [StoryPage] = [
        StoryPage(imageName: "5", title: title, description: description),
        StoryPage(imageName: "6", title: title, description: description)
    ]
    static let mockData4: [StoryPage] = [
        StoryPage(imageName: "7", title: title, description: description),
        StoryPage(imageName: "8", title: title, description: description)
    ]
    static let mockData5: [StoryPage] = [
        StoryPage(imageName: "9", title: title, description: description),
        StoryPage(imageName: "10", title: title, description: description)
    ]
    static let mockData6: [StoryPage] = [
        StoryPage(imageName: "11", title: title, description: description),
        StoryPage(imageName: "12", title: title, description: description)
    ]
    static let mockData7: [StoryPage] = [
        StoryPage(imageName: "13", title: title, description: description),
        StoryPage(imageName: "14", title: title, description: description)
    ]
    static let mockData8: [StoryPage] = [
        StoryPage(imageName: "15", title: title, description: description),
        StoryPage(imageName: "16", title: title, description: description)
    ]
    static let mockData9: [StoryPage] = [
        StoryPage(imageName: "17", title: title, description: description),
        StoryPage(imageName: "18", title: title, description: description)
    ]
}
