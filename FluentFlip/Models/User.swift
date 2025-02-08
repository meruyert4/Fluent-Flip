import Foundation

struct User: Identifiable {
    let id: String
    let name: String
    let email: String
    let status: String
    var avatar: URL?
    var learnedcards: Int?
}
