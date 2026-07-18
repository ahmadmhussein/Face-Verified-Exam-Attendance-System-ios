//
//  AdminViewController.swift
//  TestGP
//
//  Refactored to MVC
//

import UIKit
import SideMenu

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: - Outlets
    @IBOutlet weak var totalStudentsLabel: UILabel!
    @IBOutlet weak var todaySessionsLabel: UILabel!
    @IBOutlet weak var observersCountLabel: UILabel!
    @IBOutlet weak var allSessionsLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var sessionSearchBar: UISearchBar!
    @IBOutlet weak var sessionsTableView: UITableView!

    // MARK: - Properties
    var allSessions: [SessionModel] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCardsUI()
        fetchDashboardStats()
        fetchAllSessions()
    }

    // MARK: - Setup
    func setupTableView() {
        sessionsTableView.delegate = self
        sessionsTableView.dataSource = self
        sessionSearchBar.delegate = self
        
        sessionsTableView.backgroundColor = .clear
        sessionsTableView.separatorColor = .white.withAlphaComponent(0.3)
        sessionsTableView.tableFooterView = UIView()
        
        startDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    func setupCardsUI() {
        startDatePicker.tintColor = .white
        startDatePicker.overrideUserInterfaceStyle = .dark
        endDatePicker.tintColor = .white
        endDatePicker.overrideUserInterfaceStyle = .dark
        
        sessionSearchBar.searchTextField.spellCheckingType = .no
        sessionSearchBar.searchTextField.autocorrectionType = .no
        sessionSearchBar.backgroundImage = UIImage()
        sessionSearchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.9)
        
        let labels = [totalStudentsLabel, todaySessionsLabel, observersCountLabel, allSessionsLabel]
        for label in labels {
            if let cardView = label?.superview {
                cardView.backgroundColor = .white
                cardView.layer.cornerRadius = 12
                cardView.clipsToBounds = true
                cardView.layer.shadowColor = UIColor.black.cgColor
                cardView.layer.shadowOpacity = 0.05
                cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
                cardView.layer.shadowRadius = 4
            }
        }
    }

    // MARK: - Fetch Data
    func fetchDashboardStats() {
        AdminService.shared.fetchDashboardStats { [weak self] (totalStudents, observersCount, allSessionsCount, todaySessionsCount) in
            self?.totalStudentsLabel.text = "\(totalStudents)"
            self?.observersCountLabel.text = "\(observersCount)"
            self?.allSessionsLabel.text = "\(allSessionsCount)"
            self?.todaySessionsLabel.text = "\(todaySessionsCount)"
        }
    }

    func fetchAllSessions() {
        AdminService.shared.fetchAllSessions { [weak self] sessions in
            self?.allSessions = sessions
            DispatchQueue.main.async { self?.sessionsTableView.reloadData() }
        }
    }

    // MARK: - Search & Filter Logic
    @objc func dateChanged() {
        performSearch()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch()
    }

    func performSearch() {
        let subjectCode = sessionSearchBar.text ?? ""
        let start = startDatePicker.date
        let end = endDatePicker.date

        AdminService.shared.fetchSessions(subjectCode: subjectCode, startDate: start, endDate: end) { [weak self] sessions in
            self?.allSessions = sessions
            DispatchQueue.main.async { self?.sessionsTableView.reloadData() }
        }
    }

    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSessions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath)
        let session = allSessions[indexPath.row]
        
        cell.textLabel?.text = session.subjectCode
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        cell.detailTextLabel?.text = "قاعة: \(session.room) | مراقب: \(session.observerName)"
        cell.detailTextLabel?.textColor = .white.withAlphaComponent(0.8)
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    // MARK: - Actions
    @IBAction func menuButtonPressed(_ sender: Any) {
        guard let menu = storyboard?.instantiateViewController(withIdentifier: "SideMenuID") as? SideMenuNavigationController else { return }
        menu.leftSide = false
        present(menu, animated: true, completion: nil)
    }
}
