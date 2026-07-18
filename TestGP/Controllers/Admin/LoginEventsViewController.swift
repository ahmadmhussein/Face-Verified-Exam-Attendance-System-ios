import UIKit
import FirebaseFirestore

// 1. الكلاس الأساسي للصفحة
class LoginEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerStackView: UIStackView!
    
    @IBOutlet weak var tView: UIView!
    let db = Firestore.firestore()
    var logs: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesgin()
        
        fetchLogs()
    }
    
    
    
    func setUpDesgin(){
        tView.layer.cornerRadius = 10
        tView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ];
        headerStackView.layer.cornerRadius=10
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
    }
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // نستخدم الكلاس المعرف في أسفل الملف
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as? LogTableViewCell else {
            return UITableViewCell()
        }
        
        let logData = logs[indexPath.row]
        
        cell.emailLabel?.text = logData["email"] as? String ?? "No Email"
        cell.roleLabel?.text = logData["position"] as? String ?? "No Position"
        cell.broserLabel?.text = logData["ua"] as? String ?? "Unknown"
        
        if let timestamp = logData["ts"] as? Timestamp {
            let date = timestamp.dateValue()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd HH:mm"
            cell.timeLabel?.text = formatter.string(from: date)
        }
        
        return cell
    }
    func fetchLogs() {
        db.collection("login_events").order(by: "ts", descending: true).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ خطأ في فيربيس: \(error.localizedDescription)")
                return
            }

            if let documents = querySnapshot?.documents {
                print("✅ تم جلب \(documents.count) سجل من فيربيس") // سيطبع العدد في الأسفل
                self.logs = documents.map { $0.data() }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// 2. تعريف الخلية (داخل نفس الملف في الأسفل)
// هذا يغنيك عن وجود ملف مستقل للخلية
class LogTableViewCell: UITableViewCell {
    var cardView: UIView!
    var emailLabel: UILabel!
    var roleLabel: UILabel!
    var broserLabel: UILabel!
    var timeLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.masksToBounds = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        emailLabel = createLabel()
        roleLabel = createLabel()
        broserLabel = createLabel()
        timeLabel = createLabel()
        
        let stackView = UIStackView(arrangedSubviews: [broserLabel, roleLabel, emailLabel, timeLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -4),
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8)
        ])
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Cairo-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }
}
