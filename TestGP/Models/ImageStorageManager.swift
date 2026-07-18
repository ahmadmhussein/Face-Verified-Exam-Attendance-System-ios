import UIKit

class ImageStorageManager {
    static let shared = ImageStorageManager()
    
    func saveImage(_ image: UIImage, forStudentId studentId: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let studentsDirectory = documentsDirectory.appendingPathComponent("students")
        
        if !fileManager.fileExists(atPath: studentsDirectory.path) {
            do {
                try fileManager.createDirectory(at: studentsDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create directory:", error)
                return
            }
        }
        
        let fileName = "\(studentId)_\(UUID().uuidString).jpg"
        let fileURL = studentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            print("Image saved successfully at: \(fileURL.path)")
        } catch {
            print("Failed to save image:", error.localizedDescription)
        }
    }
}
