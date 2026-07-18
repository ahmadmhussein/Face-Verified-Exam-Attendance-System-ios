//
//  SelectCourseForStudentsViewController.swift
//  TestGP
//
//  Created by Ahmad on 14/07/2026.
//

import UIKit

class SelectCourseForStudentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var courses: [Course] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDummyData()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    func loadDummyData() {
        courses = [
            Course(name: "برمجة تطبيقات الهاتف", code: "CIS-109", studentCount: 28),
            Course(name: "نظم قواعد البيانات", code: "CIS-210", studentCount: 44),
            Course(name: "شبكات الحاسوب", code: "CIS-331", studentCount: 35),
            Course(name: "هندسة البرمجيات", code: "CIS-420", studentCount: 22)
        ]
        tableView.reloadData()
    }
    
    
}

extension SelectCourseForStudentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // يمكنك استخدام نفس خلية المواد السابقة CourseCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCelll", for: indexPath) as! CourseCelll
        
        cell.configure(with: courses[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 💡 التغيير الوحيد هنا: الانتقال لشاشة عرض الطلاب
        performSegue(withIdentifier: "toCourseStudents", sender: courses[indexPath.row])
    }
}
class CourseCelll: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var studentCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configure(with course: Course) {
        courseNameLabel.text = course.name
        courseCodeLabel.text = course.code
        studentCountLabel.text = "\(course.studentCount)"
    }
}
