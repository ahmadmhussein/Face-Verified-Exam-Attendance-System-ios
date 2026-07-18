//
//  TeacherChangeNameViewController.swift
//  TestGP
//
//  Created by Ahmad on 18/07/2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TeacherChangeNameViewController: UIViewController {

    @IBOutlet weak var newNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        saveButton.layer.cornerRadius = 12
        
        newNameTextField.layer.cornerRadius = 8
        newNameTextField.layer.borderWidth = 1
        newNameTextField.layer.borderColor = UIColor.systemGray5.cgColor
        newNameTextField.clipsToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: newNameTextField.frame.height))
        newNameTextField.rightView = paddingView
        newNameTextField.rightViewMode = .always
        newNameTextField.textAlignment = .right
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let newName = newNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !newName.isEmpty else {
            showAlert(title: "تنبيه", message: "يرجى إدخال الاسم الجديد")
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            showAlert(title: "خطأ", message: "يرجى تسجيل الدخول أولاً")
            return
        }
        
        saveButton.isEnabled = false
        
        let db = Firestore.firestore()
        
        db.collection("teachers").document(currentUser.uid).updateData([
            "name": newName
        ]) { [weak self] error in
            DispatchQueue.main.async {
                self?.saveButton.isEnabled = true
                
                if let error = error {
                    self?.showAlert(title: "خطأ", message: "حدث خطأ أثناء حفظ الاسم")
                } else {
                    let changeRequest = currentUser.createProfileChangeRequest()
                    changeRequest.displayName = newName
                    changeRequest.commitChanges(completion: nil)
                    
                    let alert = UIAlertController(title: "نجاح", message: "تم تغيير الاسم بنجاح", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: { _ in
                        if let nav = self?.navigationController {
                            nav.popViewController(animated: true)
                        } else {
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
