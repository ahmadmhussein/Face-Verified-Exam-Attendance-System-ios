//
//  AttendanceViewController.swift
//  TestGP
//
//  Refactored to MVC
//

import UIKit

protocol StudentAttendanceCellDelegate: AnyObject {
    func didChangeAttendance(for index: Int, isPresent: Bool)
}

class AttendanceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var students: [StudentAttendance] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        saveButton.layer.cornerRadius = 14
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOpacity = 0.2
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        saveButton.layer.shadowRadius = 6
    }
    
    func fetchData() {
        TeacherService.shared.fetchDummyStudentsForAttendance { [weak self] data in
            self?.students = data
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let presentCount = students.filter { $0.isPresent }.count
        let alert = UIAlertController(title: "تم الحفظ", message: "تم حفظ السجل بنجاح. عدد الحضور: \(presentCount)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AttendanceViewController: UITableViewDelegate, UITableViewDataSource, StudentAttendanceCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCelll", for: indexPath) as! StudentAttendanceCell
        
        cell.configure(with: students[indexPath.row], index: indexPath.row, delegate: self)
        
        return cell
    }
    
    func didChangeAttendance(for index: Int, isPresent: Bool) {
        students[index].isPresent = isPresent
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110 
    }
}

class StudentAttendanceCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var attendanceSwitch: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    
    weak var delegate: StudentAttendanceCellDelegate?
    var studentIndex: Int = 0
    
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

    func configure(with student: StudentAttendance, index: Int, delegate: StudentAttendanceCellDelegate) {
        self.studentIndex = index
        self.delegate = delegate
        
        nameLabel.text = student.name
        idLabel.text = student.universityId
        attendanceSwitch.isOn = student.isPresent
        
        updateStatusUI()
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        updateStatusUI()
        delegate?.didChangeAttendance(for: studentIndex, isPresent: sender.isOn)
    }
    
    func updateStatusUI() {
        if attendanceSwitch.isOn {
            statusLabel.text = "حاضر"
            statusLabel.textColor = UIColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 1.0)
        } else {
            statusLabel.text = "غائب"
            statusLabel.textColor = .systemRed
        }
    }
}
