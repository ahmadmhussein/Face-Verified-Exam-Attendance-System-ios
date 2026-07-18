//
//  TeacherChangePasswordViewController.swift
//  TestGP
//
//  Created by Ahmad on 18/07/2026.
//

import UIKit
import FirebaseAuth

class TeacherChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        updateButton.layer.cornerRadius = 12
        
        setupTextField(currentPasswordTextField)
        setupTextField(newPasswordTextField)
        
        // إخفاء النص (نجوم/نقاط) لأنها كلمات مرور
        currentPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
    }
    
    func setupTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.clipsToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.rightView = paddingView
        textField.rightViewMode = .always
        textField.textAlignment = .right
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty,
              let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(title: "تنبيه", message: "يرجى تعبئة جميع الحقول")
            return
        }
        
        // التحقق من أن كلمة المرور الجديدة لا تقل عن 6 أحرف (شرط الفايربيز)
        guard newPassword.count >= 6 else {
            showAlert(title: "تنبيه", message: "كلمة المرور الجديدة يجب أن تكون 6 أحرف على الأقل")
            return
        }
        
        guard let user = Auth.auth().currentUser, let email = user.email else {
            showAlert(title: "خطأ", message: "يرجى تسجيل الدخول أولاً")
            return
        }
        
        updateButton.isEnabled = false
        
        // 1. إعادة التحقق من كلمة المرور القديمة
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.updateButton.isEnabled = true
                    self.showAlert(title: "خطأ", message: "كلمة المرور الحالية غير صحيحة")
                }
                return
            }
            
            // 2. إذا القديمة صحيحة، نقوم بتحديثها للجديدة
            user.updatePassword(to: newPassword) { error in
                DispatchQueue.main.async {
                    self.updateButton.isEnabled = true
                    
                    if let error = error {
                        self.showAlert(title: "خطأ", message: "حدث خطأ أثناء تحديث كلمة المرور")
                    } else {
                        let alert = UIAlertController(title: "نجاح", message: "تم تغيير كلمة المرور بنجاح", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: { _ in
                            self.navigateBack()
                        }))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
 
    
    func navigateBack() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
