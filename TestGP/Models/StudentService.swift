import Foundation
import FirebaseFirestore
import FirebaseAuth

class StudentService {
    static let shared = StudentService()
    private let db = Firestore.firestore()
    
    func fetchCurrentStudent(completion: @escaping (Result<StudentProfile, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            let error = NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
            completion(.failure(error))
            return
        }
        
        let userUid = currentUser.uid
        db.collection("students").document(userUid).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists {
                let name = document.data()?["name"] as? String ?? "طالب غير معروف"
                let studentId = document.data()?["studentId"] as? String ?? userUid
                
                let student = StudentProfile(id: userUid, name: name, studentId: studentId)
                completion(.success(student))
            } else {
                let notFoundError = NSError(domain: "DBError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Student document not found"])
                completion(.failure(notFoundError))
            }
        }
    }
}
