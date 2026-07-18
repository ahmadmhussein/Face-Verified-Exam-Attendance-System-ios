//
//  NotificationsViewController.swift
//  TestGP
//
//  Created by Ahmad on 12/07/2026.
//
import UIKit

struct AppNotification {
    let title: String
    let body: String
    let iconName: String
}

class NotificationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var notificationsArray: [AppNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadDummyData()
    }
    
    func setupTableView() {
        guard tableView != nil else { return }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.systemGray6
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    func loadDummyData() {
        notificationsArray = [
            AppNotification(title: "تذكير: جلسة اختبار", body: "تبدأ الجلسة بعد 30 دقيقة في القاعة 101.", iconName: "building.columns.fill"),
            AppNotification(title: "تحديث جدول المحاضرات", body: "تم تحديث جدول المحاضرات للفصل الدراسي الثاني. يرجى الاطلاع على التغييرات.", iconName: "exclamationmark.triangle.fill"),
            AppNotification(title: "رسالة من الإدارة", body: "تم تمديد الموعد النهائي لتقديم طلبات التخرج إلى تاريخ 25 مايو 2026.", iconName: "person.fill"),
            AppNotification(title: "تغيير قاعة الامتحان", body: "تم نقل امتحان مادة نظم قواعد البيانات إلى المدرج الكندي بدلاً من القاعة 105.", iconName: "calendar")
        ]
        tableView.reloadData()
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationTableViewCell
        
        let notification = notificationsArray[indexPath.row]
        cell.configure(with: notification)
        
        return cell
    }
}

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        cardView.layer.cornerRadius = 14
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configure(with notification: AppNotification) {
        titleLabel.text = notification.title
        bodyLabel.text = notification.body
        
        if iconImageView != nil {
            iconImageView.image = UIImage(systemName: notification.iconName)
        }
    }
}
