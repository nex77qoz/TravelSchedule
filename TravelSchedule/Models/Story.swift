import Foundation

struct Story: Hashable, Identifiable {
    let id = UUID()
    let previewImageName: String
    let pageImageNames: [String]
    let title: String
    let text: String
    var isRead: Bool
}

extension Story {
    static let sampleData = [
        Story(
            previewImageName: "preview1",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview2",
            pageImageNames: ["big2-1", "big2-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview3",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview4",
            pageImageNames: ["big2-1", "big2-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview5",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview6",
            pageImageNames: ["big2-1", "big2-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview7",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview8",
            pageImageNames: ["big2-1", "big2-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview9",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        )
    ]
}
