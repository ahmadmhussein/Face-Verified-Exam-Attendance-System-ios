//
//  EnrolledStudentsViewController.swift
//  TestGP
//
//  Created by Ahmad on 25/05/2026.
//

import UIKit
import FirebaseFirestore

class EnrolledStudentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var tableData: [SubjectSection] = []
    var filteredData: [SubjectSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        fetchData()
    }
    
    func fetchData() {
        db.collection("subjects").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if error != nil { return }
            guard let subjectDocs = querySnapshot?.documents else { return }
            self.tableData.removeAll()
            
            let group = DispatchGroup()
            
            for doc in subjectDocs {
                let subName = doc.data()["name"] as? String ?? ""
                let subCode = doc.data()["code"] as? String ?? ""
                
                var currentSection = SubjectSection(subjectName: subName, subjectCode: subCode, students: [])
                
                group.enter()
                
                self.db.collection("students").getDocuments { (studentSnapshot, studentError) in
                    if let studentDocs = studentSnapshot?.documents {
                        for sDoc in studentDocs {
                            let sData = sDoc.data()
                            
                            if let enrolled = sData["enrolledSubjects"] as? [[String: Any]] {
                                let isEnrolled = enrolled.contains(where: { $0["subjectCode"] as? String == subCode })
                                
                                if isEnrolled {
                                    let student = Student(
                                        studentId: sData["studentId"] as? String ?? "",
                                        name: sData["name"] as? String ?? "",
                                        major: "",
                                        email: "",
                                        facePath: ""
                                    )
                                    currentSection.students.append(student)
                                }
                            }
                        }
                    }
                    self.tableData.append(currentSection)
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.tableData.sort(by: { $0.subjectName < $1.subjectName })
                self.filteredData = self.tableData
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData[section].students.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let subject = filteredData[section]
        return "\(subject.subjectName) (\(subject.subjectCode)) - \(subject.students.count) طلاب"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        let student = filteredData[indexPath.section].students[indexPath.row]
        
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = "الرقم الجامعي: \(student.studentId)"
        
        cell.textLabel?.textAlignment = .right
        cell.detailTextLabel?.textAlignment = .right
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 6/255, green: 78/255, blue: 59/255, alpha: 1.0) // اللون الأخضر الداكن #064e3b
        
        let label = UILabel()
        let subject = filteredData[section]
        label.text = "  \(subject.subjectName) (\(subject.subjectCode))  |  \(subject.students.count) طلاب"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45 // زيادة ارتفاع شريط المادة ليصبح مريحاً للعين
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = tableData
        } else {
            filteredData = tableData.map { section in
                var mutableSection = section
                mutableSection.students = section.students.filter { student in
                    return student.name.contains(searchText) || student.studentId.contains(searchText)
                }
                return mutableSection
            }.filter { !$0.students.isEmpty }
        }
        tableView.reloadData()
    }
}
