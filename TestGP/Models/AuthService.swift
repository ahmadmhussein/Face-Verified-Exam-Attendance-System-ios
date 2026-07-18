import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    static let shared = AuthService()
    private let db = Firestore.firestore()
    
    func login(email: String, password: String, completion: @escaping (Result<UserPosition, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self?.fetchUserRole(email: email, completion: completion)
        }
    }
    
    private func fetchUserRole(email: String, completion: @escaping (Result<UserPosition, Error>) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                let notFoundError = NSError(domain: "DBError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in DB"])
                completion(.failure(notFoundError))
                return
            }
            
            let userData = documents[0].data()
            let positionString = userData["position"] as? String ?? ""
            let position = UserPosition(rawValue: positionString) ?? .unknown
            
            completion(.success(position))
        }
    }
}
