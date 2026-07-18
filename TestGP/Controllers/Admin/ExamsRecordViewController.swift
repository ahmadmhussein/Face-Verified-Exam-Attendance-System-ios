import UIKit
import FirebaseFirestore

class ExamsRecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var sessionsList: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 220
        
        fetchSessionsFromFirestore()
    }
    
    func fetchSessionsFromFirestore() {
        db.collection("sessions").order(by: "createdAt", descending: true).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching sessions: \(error)")
                return
            }
            
            self.sessionsList = querySnapshot?.documents.map { doc -> [String: Any] in
                var data = doc.data()
                data["documentID"] = doc.documentID
                return data
            } ?? []
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExamLogCell", for: indexPath) as? ExamLogTableViewCell else {
            return UITableViewCell()
        }
        
        let session = sessionsList[indexPath.row]
        
        cell.subjectNameLabel.text = session["subjectCode"] as? String ?? "-"
        cell.sectionNumberLabel.text = session["section"] as? String ?? "-"
        cell.roomNameLabel.text = session["room"] as? String ?? "-"
        cell.observerNameLabel.text = session["observerName"] as? String ?? "-"
        
        if let startTimeString = session["startTime"] as? String {
            cell.examTimeLabel.text = formatISOString(startTimeString)
        } else {
            cell.examTimeLabel.text = "-"
        }
        
        // استقبال أكشن الحذف
        cell.onDeletePressed = { [weak self] in
            guard let self = self else { return }
            if let sessionID = session["documentID"] as? String {
                let subjectCode = session["subjectCode"] as? String ?? ""
             
                self.showDeleteConfirmationAlert(sessionID: sessionID, subjectName: subjectCode)
            }
        }
        
        cell.onEditPressed = {
            // أكشن التعديل لاحقاً
        }
        
        return cell
    }
    
    func formatISOString(_ isoString: String) -> String {
        if isoString.count >= 16 {
            let index = isoString.index(isoString.startIndex, offsetBy: 16)
            return String(isoString[..<index]).replacingOccurrences(of: "T", with: "   الساعة: ")
        }
        return isoString
    }
    
    // MARK: - 🔑 دوال الحذف والـ Alert (تأكد من وجودها هنا تماماً قبل القوس الأخير للكلاس)
    
    func showDeleteConfirmationAlert(sessionID: String, subjectName: String) {
        let alert = UIAlertController(
            title: "تأكيد الحذف",
            message: "هل أنت متأكد من رغبتك في حذف جلسة اختبار مادة (\(subjectName))؟ لا يمكن التراجع عن هذا الإجراء.",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "حذف", style: .destructive) { [weak self] _ in
            self?.deleteSessionFromFirestore(documentID: sessionID)
        }
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteSessionFromFirestore(documentID: String) {
        db.collection("sessions").document(documentID).delete { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("خطأ أثناء الحذف: \(error.localizedDescription)")
                let errorAlert = UIAlertController(title: "فشلت العملية", message: "حدث خطأ أثناء الحذف.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "حسناً", style: .default))
                self.present(errorAlert, animated: true)
            } else {
                print("تم الحذف بنجاح!")
            }
        }
    }
} // القوس الأخير للكلاس الرئيسي

// MARK: - كلاس الخلية المدمج
class ExamLogTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var sectionNumberLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var examTimeLabel: UILabel!
    @IBOutlet weak var observerNameLabel: UILabel!
    
    var onEditPressed: (() -> Void)?
    var onDeletePressed: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        onEditPressed?()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        onDeletePressed?()
    }
}
