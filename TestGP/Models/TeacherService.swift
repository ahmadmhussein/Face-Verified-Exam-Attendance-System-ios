import Foundation
import FirebaseAuth
import FirebaseFirestore

struct StudentAttendance {
    let name: String
    let universityId: String
    var isPresent: Bool
}

class TeacherService {
    static let shared = TeacherService()
    private let db = Firestore.firestore()
    
    func addStudent(fullName: String, universityId: String, email: String, password: String, college: String, subject: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            
            let studentData: [String: Any] = [
                "uid": uid,
                "fullName": fullName,
                "universityId": universityId,
                "email": email,
                "college": college,
                "subjects": subject,
                "role": "student",
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            self.db.collection("users").document(uid).setData(studentData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func fetchDummyStudentsForAttendance(completion: @escaping ([StudentAttendance]) -> Void) {
        let students = [
            StudentAttendance(name: "أحمد حسن الباز", universityId: "ID: 20210345", isPresent: true),
            StudentAttendance(name: "سارة محمود علي", universityId: "ID: 20210781", isPresent: false),
            StudentAttendance(name: "سارة محمود الباز", universityId: "ID: 20210781", isPresent: true),
            StudentAttendance(name: "صيبان حسن القنوي", universityId: "ID: 20210785", isPresent: true),
            StudentAttendance(name: "رسان حين الحمد", universityId: "ID: 20210787", isPresent: false)
        ]
        completion(students)
    }
}
