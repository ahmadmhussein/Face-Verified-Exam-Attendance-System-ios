//
//  AddUserViewController.swift
//  TestGP
//
//  Refactored to MVC
//

import UIKit

class AddUserViewController: UIViewController {

    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var passwordCard: UIView!
    @IBOutlet weak var roleButton: UIButton!
    @IBOutlet weak var RoleCard: UIView!
    @IBOutlet weak var NameCard: UIView!
    @IBOutlet weak var PhoneNumberCard: UIView!
    @IBOutlet weak var userNumberTextFeild: UITextField!
    @IBOutlet weak var userNumberCard: UIView!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var PhoneNumberTextFeild: UITextField!
    @IBOutlet weak var EmailTextFeild: UITextField!
    @IBOutlet weak var EmailCard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        design()
        setupRoleMenu()
    }
    
    @IBAction func Completebutton(_ sender: UIButton) {
        guard let name = NameTextField.text, !name.isEmpty,
              let email = EmailTextFeild.text, !email.isEmpty,
              let idNumber = userNumberTextFeild.text, !idNumber.isEmpty,
              let phone = PhoneNumberTextFeild.text, !phone.isEmpty,
              let position = roleButton.title(for: .normal) else {
            print("تأكد من تعبئة كافة الحقول")
            return
        }

        AdminService.shared.addUser(name: name, email: email, idNumber: idNumber, phone: phone, position: position) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    print("تم الحفظ بنجاح!")
                    self?.dismiss(animated: true)
                case .failure(let error):
                    print("خطأ في الحفظ: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        ContentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            ContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            ContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            ContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            ContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

            ContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    func design() {
        let cards = [NameCard, userNumberCard, EmailCard, PhoneNumberCard, RoleCard, passwordCard]
        
        for card in cards {
            card?.backgroundColor = .white
            card?.layer.cornerRadius = 10
            card?.layer.shadowColor = UIColor.black.cgColor
            card?.layer.shadowOffset = CGSize(width: 0, height: 2)
            card?.layer.shadowRadius = 4
            card?.layer.shadowOpacity = 0.3
            card?.layer.masksToBounds = false
        }
    }
    
    func setupRoleMenu() {
        let option1 = UIAction(title: "مراقب", image: UIImage(systemName: "person.fill")) { _ in
            self.roleButton.setTitle("مراقب", for: .normal)
        }
        let option2 = UIAction(title: "رئيس قاعة", image: UIImage(systemName: "person.2.fill")) { _ in
            self.roleButton.setTitle("رئيس قاعة", for: .normal)
        }
        let option3 = UIAction(title: "مشرف نظام", image: UIImage(systemName: "shield.fill")) { _ in
            self.roleButton.setTitle("مشرف نظام", for: .normal)
        }

        let menu = UIMenu(title: "اختر دور المستخدم", children: [option1, option2, option3])
        roleButton.menu = menu
        roleButton.showsMenuAsPrimaryAction = true
    }
}
