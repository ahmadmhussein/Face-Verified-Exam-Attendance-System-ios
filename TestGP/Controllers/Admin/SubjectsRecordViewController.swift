//
//  SubjectsRecordViewController.swift
//  TestGP
//
//  Created by Ahmad on 26/05/2026.
//
import UIKit
import FirebaseFirestore

class SubjectsRecordViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var subjectsArray: [Subject] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchSubjects()
    }
    
    func setupTableView() {
        guard tableView != nil else { return }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.systemGray6
    }
    
    func fetchSubjects() {
        db.collection("subjects").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = querySnapshot?.documents else { return }
            
            self.subjectsArray = []
            
            for document in documents {
                let data = document.data()
                
                let name = data["name"] as? String ?? ""
                let code = data["code"] as? String ?? ""
                let department = data["department"] as? String ?? ""
                let college = data["college"] as? String ?? ""
                let section = data["section"] as? String ?? ""
                
                let subject = Subject(id: document.documentID,
                                      name: name,
                                      code: code,
                                      department: department,
                                      college: college,
                                      section: section)
                
                self.subjectsArray.append(subject)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SubjectsRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectTableViewCell
        
        let currentSubject = subjectsArray[indexPath.row]
        cell.configure(with: currentSubject)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

class SubjectTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var subjectnumberLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.04
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
        subjectnumberLabel.layer.masksToBounds = true
        subjectnumberLabel.layer.cornerRadius = 6
        subjectnumberLabel.backgroundColor = UIColor.systemGray6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configure(with subject: Subject) {
        subjectNameLabel.text = subject.name
        subjectnumberLabel.text = "  \(subject.code)  "
        departmentLabel.text = "\(subject.department) - \(subject.college)"
    }
}

