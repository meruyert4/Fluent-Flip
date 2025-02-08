import Foundation

struct User: Identifiable {
    let id: String
    let name: String
    let email: String
    var status: String
    var avatar: URL?
    var learnedcards: Int?
}
