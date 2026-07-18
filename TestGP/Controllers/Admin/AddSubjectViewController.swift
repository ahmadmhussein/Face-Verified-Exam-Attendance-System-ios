//
//  AddSubjectViewController.swift
//  TestGP
//
//  Created by Ahmad on 25/04/2026.
//

import UIKit
import FirebaseFirestore

class AddSubjectViewController: UIViewController {
    
    @IBOutlet weak var subjectCodeTextField: UITextField!
    @IBOutlet weak var sectionNumberTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var AddSubCard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
    }
    
    func setUpDesign() {
        AddSubCard.layer.cornerRadius = 15
        AddSubCard.layer.shadowColor = UIColor.black.cgColor
        AddSubCard.layer.shadowOpacity = 0.1
        AddSubCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        AddSubCard.layer.shadowRadius = 10
        
        sectionNumberTextField.keyboardType = .numberPad
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let code = subjectCodeTextField.text, !code.isEmpty,
              let name = subjectNameTextField.text, !name.isEmpty,
              let section = sectionNumberTextField.text, !section.isEmpty else {
            showAlert(title: "تنبيه", message: "يرجى تعبئة جميع الحقول")
            return
        }
        
        let db = Firestore.firestore()
        let newSubject: [String: Any] = [
            "subjectCode": code,
            "sectionNumber": section,
            "department": departmentTextField.text ?? "",
            "college": collegeTextField.text ?? "",
            "subjectName": name,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("subjects").addDocument(data: newSubject) { [weak self] err in
            if let err = err {
                print("Error adding document: \(err)")
                self?.showAlert(title: "خطأ", message: "تعذر الحفظ، حاول مرة أخرى")
            } else {
                self?.showAlert(title: "تم بنجاح", message: "تمت إضافة المادة بنجاح")
                self?.clearFields()
            }
        }
    }
    
    func clearFields() {
        subjectCodeTextField.text = ""
        subjectNameTextField.text = ""
        sectionNumberTextField.text = ""
        departmentTextField.text = ""
        collegeTextField.text = ""
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "موافق", style: .default))
        
        alert.view.semanticContentAttribute = .forceRightToLeft
        
        present(alert, animated: true)
    }
}
