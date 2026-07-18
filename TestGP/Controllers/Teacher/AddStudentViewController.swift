//
//  AddStudentViewController.swift
//  TestGP
//
//  Refactored to MVC
//

import UIKit

class AddStudentViewController: UIViewController {

    @IBOutlet var cardViews: [UIView]!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var universityIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var collegeButton: UIButton!
    @IBOutlet weak var subjectsButton: UIButton!
    
    var selectedCollege: String? = nil
    var selectedSubject: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardsUI()
        setupDropdownMenus()
    }
    
    func setupCardsUI() {
        guard cardViews != nil else { return }
        for card in cardViews {
            card.layer.cornerRadius = 12
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.05
            card.layer.shadowOffset = CGSize(width: 0, height: 2)
            card.layer.shadowRadius = 4
            card.backgroundColor = .white
        }
    }
    
    func setupDropdownMenus() {
        let itAction = UIAction(title: "كلية تكنولوجيا المعلومات وعلوم الحاسوب") { _ in
            self.selectedCollege = "كلية تكنولوجيا المعلومات وعلوم الحاسوب"
            self.collegeButton.setTitle("كلية تكنولوجيا المعلومات", for: .normal)
        }
        let engAction = UIAction(title: "كلية الهندسة") { _ in
            self.selectedCollege = "كلية الهندسة"
            self.collegeButton.setTitle("كلية الهندسة", for: .normal)
        }
        
        collegeButton.menu = UIMenu(title: "اختر الكلية", children: [itAction, engAction])
        collegeButton.showsMenuAsPrimaryAction = true
        
        let appDevAction = UIAction(title: "برمجة تطبيقات الهاتف - CIS-109") { _ in
            self.selectedSubject = "CIS-109"
            self.subjectsButton.setTitle("برمجة تطبيقات الهاتف", for: .normal)
        }
        let dbAction = UIAction(title: "نظم قواعد البيانات") { _ in
            self.selectedSubject = "نظم قواعد البيانات"
            self.subjectsButton.setTitle("نظم قواعد البيانات", for: .normal)
        }
        let networkAction = UIAction(title: "شبكات الحاسوب") { _ in
            self.selectedSubject = "شبكات الحاسوب"
            self.subjectsButton.setTitle("شبكات الحاسوب", for: .normal)
        }
        
        subjectsButton.menu = UIMenu(title: "اختر المادة", children: [appDevAction, dbAction, networkAction])
        subjectsButton.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let fullName = fullNameTextField.text, !fullName.isEmpty,
              let universityId = universityIdTextField.text, !universityId.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let college = selectedCollege,
              let subject = selectedSubject else {
            showAlert(title: "تنبيه", message: "يرجى تعبئة جميع الحقول واختيار الكلية والمادة.")
            return
        }
        
        let generatedEmail = "\(universityId)@ses.yu.edu.jo"
        
        TeacherService.shared.addStudent(fullName: fullName, universityId: universityId, email: generatedEmail, password: password, college: college, subject: subject) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.showAlert(title: "تم بنجاح", message: "تم تسجيل الطالب وإضافته للنظام بنجاح.") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    self?.showAlert(title: "خطأ", message: error.localizedDescription)
                }
            }
        }
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
