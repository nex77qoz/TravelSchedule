import Foundation

struct Story: Identifiable {
    var id = UUID()
    var imageName: String
    var isShowed: Bool = false
    var title: String
    var totalPages: [StoryPage]
}

extension Story {
    static let title = Array(repeating: "title", count: 7).joined(separator: " ").capitalized

    static let mockData: [Story] = [
        Story(imageName: "preview1", title: title, totalPages: StoryPage.mockData1),
        Story(imageName: "preview2", title: title, totalPages: StoryPage.mockData2),
        Story(imageName: "preview3", title: title, totalPages: StoryPage.mockData3),
        Story(imageName: "preview4", title: title, totalPages: StoryPage.mockData4),
        Story(imageName: "preview5", title: title, totalPages: StoryPage.mockData5),
        Story(imageName: "preview6", title: title, totalPages: StoryPage.mockData6),
        Story(imageName: "preview7", title: title, totalPages: StoryPage.mockData7),
        Story(imageName: "preview8", title: title, totalPages: StoryPage.mockData8),
        Story(imageName: "preview9", title: title, totalPages: StoryPage.mockData9)
    ]
}
