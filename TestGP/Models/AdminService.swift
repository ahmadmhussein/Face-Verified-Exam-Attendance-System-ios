import Foundation
import FirebaseFirestore
import FirebaseAuth

class AdminService {
    static let shared = AdminService()
    private let db = Firestore.firestore()

    func fetchDashboardStats(completion: @escaping (Int, Int, Int, Int) -> Void) {
        var totalStudents = 0
        var observersCount = 0
        var allSessionsCount = 0
        var todaySessionsCount = 0
        let group = DispatchGroup()
        
        group.enter()
        db.collection("students").getDocuments { (snapshot, _) in
            totalStudents = snapshot?.documents.count ?? 0
            group.leave()
        }
        
        group.enter()
        db.collection("users").whereField("position", isEqualTo: "observer").getDocuments { (snapshot, _) in
            observersCount = snapshot?.documents.count ?? 0
            group.leave()
        }
        
        group.enter()
        db.collection("exam_attendance_sessions").getDocuments { (snapshot, _) in
            allSessionsCount = snapshot?.documents.count ?? 0
            group.leave()
        }
        
        group.enter()
        let startOfToday = Calendar.current.startOfDay(for: Date())
        db.collection("exam_attendance_sessions")
            .whereField("createdAt", isGreaterThanOrEqualTo: startOfToday)
            .getDocuments { (snapshot, _) in
                todaySessionsCount = snapshot?.documents.count ?? 0
                group.leave()
            }
            
        group.notify(queue: .main) {
            completion(totalStudents, observersCount, allSessionsCount, todaySessionsCount)
        }
    }
    
    func fetchSessions(subjectCode: String, startDate: Date, endDate: Date, completion: @escaping ([SessionModel]) -> Void) {
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: endDate))!
        
        var query: Query = db.collection("exam_attendance_sessions")
        
        if !subjectCode.isEmpty {
            query = query.whereField("subjectCode", isEqualTo: subjectCode)
        }
        
        query = query.whereField("createdAt", isGreaterThanOrEqualTo: start)
                     .whereField("createdAt", isLessThan: end)
                     
        query.getDocuments { (snapshot, _) in
            let models = snapshot?.documents.map { SessionModel(document: $0) } ?? []
            completion(models)
        }
    }
    
    func fetchAllSessions(completion: @escaping ([SessionModel]) -> Void) {
        db.collection("exam_attendance_sessions").order(by: "createdAt", descending: true).getDocuments { (snapshot, _) in
            let models = snapshot?.documents.map { SessionModel(document: $0) } ?? []
            completion(models)
        }
    }
    
    func addUser(name: String, email: String, idNumber: String, phone: String, position: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "idNumber": idNumber,
            "phone": phone,
            "position": position,
            "createdAt": FieldValue.serverTimestamp()
        ]

        db.collection("Users").addDocument(data: userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
