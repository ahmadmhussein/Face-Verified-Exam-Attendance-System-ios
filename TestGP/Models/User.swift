import Foundation

struct User {
    let email: String
    let position: UserPosition
}

enum UserPosition: String {
    case admin
    case observer
    case teacher
    case student
    case unknown
}
