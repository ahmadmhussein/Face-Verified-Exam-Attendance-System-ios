//
//  ViewController.swift
//  TestGP
//
//  Refactored to MVC
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        loginCardView.layer.cornerRadius = 15.0
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print(" الرجاء إدخال الإيميل وكلمة المرور")
            return
        }
        
        print(" جاري التحقق من بيانات الدخول...")
        
        AuthService.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let position):
                    print("👤 صفة المستخدم الحالية هي: \(position.rawValue)")
                    self?.navigateBasedOn(position: position)
                case .failure(let error):
                    print(" فشل تسجيل الدخول: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func navigateBasedOn(position: UserPosition) {
        switch position {
        case .admin:
            performSegue(withIdentifier: "goToAdmin", sender: self)
        case .observer:
            performSegue(withIdentifier: "goToObserver", sender: self)
        case .teacher:
            performSegue(withIdentifier: "goToTeacher", sender: self)
        case .student:
            performSegue(withIdentifier: "goToStudent", sender: self)
        case .unknown:
            print("❓ صفة غير معروفة")
        }
    }
}
