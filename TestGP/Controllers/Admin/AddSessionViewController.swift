//
//  AddSessionViewController.swift
//  TestGP
//
//  Created by Ahmad on 24/05/2026.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddSessionViewController: UIViewController {

    @IBOutlet weak var SubjectCardView: UIView!
    @IBOutlet weak var SectionCardView: UIView!
    @IBOutlet weak var RoomCardView: UIView!
    @IBOutlet weak var StartTimeCardView: UIView!
    @IBOutlet weak var EndTimeCardView: UIView!
    @IBOutlet weak var ObserverCardView: UIView!
    @IBOutlet weak var DurationCardView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subjectSelectButton: UIButton!
    
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var sectionTextField: UITextField!
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var roomTextField: UITextField!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var observerLabel: UILabel!
    @IBOutlet weak var observerTextField: UITextField!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationTextField: UITextField!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    let db = Firestore.firestore()
    var selectedSubjectCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchSubjectsToMenu()
    }
    
    func setupUI() {
        let cards = [SubjectCardView, SectionCardView, RoomCardView, StartTimeCardView, EndTimeCardView, ObserverCardView, DurationCardView]
        
        cards.forEach { card in
            guard let card = card else { return }
            card.layer.cornerRadius = 14
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.04
            card.layer.shadowOffset = CGSize(width: 0, height: 3)
            card.layer.shadowRadius = 5
        }
        
        saveButton.layer.cornerRadius = 14
        
        startTimePicker.locale = Locale(identifier: "en_US")
        startTimePicker.calendar = Calendar(identifier: .gregorian)
        startTimePicker.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        endTimePicker.locale = Locale(identifier: "en_US")
        endTimePicker.calendar = Calendar(identifier: .gregorian)
        endTimePicker.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    func fetchSubjectsToMenu() {
        db.collection("subjects").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if error != nil { return }
            guard let documents = snapshot?.documents else { return }
            
            var menuActions: [UIAction] = []
            
            for doc in documents {
                let subjectData = doc.data()
                let name = subjectData["name"] as? String ?? ""
                let code = subjectData["code"] as? String ?? ""
                
                let action = UIAction(title: "\(name) (\(code))", image: nil) { _ in
                    self.selectedSubjectCode = code
                    self.subjectSelectButton.setTitle(name, for: .normal)
                }
                menuActions.append(action)
            }
            
            DispatchQueue.main.async {
                if !menuActions.isEmpty {
                    self.subjectSelectButton.setTitle("اضغط لاختيار المادة", for: .normal)
                    let menu = UIMenu(title: "اختر المادة", children: menuActions)
                    self.subjectSelectButton.menu = menu
                    self.subjectSelectButton.showsMenuAsPrimaryAction = true
                } else {
                    self.subjectSelectButton.setTitle("لا توجد مواد مضافة", for: .normal)
                }
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let subjectCode = selectedSubjectCode else {
            showAlert(title: "تنبيه", message: "الرجاء اختيار المادة من القائمة")
            return
        }
        
        guard let section = sectionTextField.text, !section.isEmpty,
              let room = roomTextField.text, !room.isEmpty,
              let observer = observerTextField.text, !observer.isEmpty else {
            
            showAlert(title: "تنبيه", message: "الرجاء تعبئة جميع الحقول المطلوبة")
            return
        }
        
        var createdByData: [String: Any] = [
            "email": "test@example.com",
            "name": "Ahmad Hussein",
            "role": "admin"
        ]
        
        if let currentUser = Auth.auth().currentUser {
            createdByData["email"] = currentUser.email ?? "no-email@test.com"
            createdByData["name"] = currentUser.displayName ?? "Ahmad Hussein"
            createdByData["role"] = "admin"
        }
        
        let sessionData: [String: Any] = [
            "createdAt": FieldValue.serverTimestamp(),
            "createdBy": createdByData,
            "startTime": startTimePicker.date,
            "endTime": endTimePicker.date,
            "room": room,
            "section": section,
            "observerName": observer,
            "subjectCode": subjectCode
        ]
        
        db.collection("sessions").addDocument(data: sessionData) { error in
            if let error = error {
                self.showAlert(title: "خطأ", message: "فشل حفظ البيانات: \(error.localizedDescription)")
            } else {
                let alert = UIAlertController(title: "تم بنجاح", message: "تم حفظ جلسة الاختبار بنجاح", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "موافق", style: .default))
        self.present(alert, animated: true)
    }
}
