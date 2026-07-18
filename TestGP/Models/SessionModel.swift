import Foundation
import FirebaseFirestore

struct SessionModel {
    let subjectCode: String
    let room: String
    let observerName: String
    
    init(document: QueryDocumentSnapshot) {
        let data = document.data()
        self.subjectCode = data["subjectCode"] as? String ?? "N/A"
        self.room = data["room"] as? String ?? "---"
        self.observerName = data["observerName"] as? String ?? "---"
    }
}
