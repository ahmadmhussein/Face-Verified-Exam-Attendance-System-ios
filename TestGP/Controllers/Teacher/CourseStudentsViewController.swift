import UIKit

struct CourseStudent {
    let name: String
    let universityId: String
}

class CourseStudentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var students: [CourseStudent] = []

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
        students = [
            CourseStudent(name: "أحمد حسن الباز", universityId: "20210345"),
            CourseStudent(name: "سارة محمود علي", universityId: "20210781"),
            CourseStudent(name: "سارة محمود الباز", universityId: "20210781"),
            CourseStudent(name: "صيبان حسن القنوي", universityId: "20210785"),
            CourseStudent(name: "رسان حين الحمد", universityId: "20210787")
        ]
        tableView.reloadData()
    }
    
   
}

extension CourseStudentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCustomCell", for: indexPath) as! StudentCustomCell
        
        cell.configure(with: students[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        
    }
}

class StudentCustomCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
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
    
    func configure(with student: CourseStudent) {
        nameLabel.text = student.name
        idLabel.text = "الرقم الجامعي: \(student.universityId)"
    }
}
