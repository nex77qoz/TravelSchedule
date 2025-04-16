import Foundation

extension Bundle {
    public var appBuild: String {
        getInfo("CFBundleVersion")
    }

    public var appVersionLong: String {
        getInfo("CFBundleShortVersionString")
    }

    private func getInfo(_ str: String) -> String {
        infoDictionary?[str] as? String ?? ""
    }
}
