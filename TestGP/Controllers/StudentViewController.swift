//
//  StudentViewController.swift
//  TestGP
//
//  Refactored to MVC
//

import UIKit

class StudentViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var studentCardView: UIView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Properties
    private let cameraManager = CameraManager()
    private var currentStudent: StudentProfile?
    private var totalPhotosTaken = 0
    private var photosToTakeInBatch = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCamera()
        fetchStudentData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraManager.updatePreviewFrame(cameraContainerView.bounds)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopSession()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        cameraContainerView.layer.cornerRadius = 16
        cameraContainerView.clipsToBounds = true
        confirmButton.layer.cornerRadius = 12
        
        studentCardView.layer.cornerRadius = 16
        studentCardView.layer.shadowColor = UIColor.black.cgColor
        studentCardView.layer.shadowOpacity = 0.05
        studentCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        studentCardView.layer.shadowRadius = 6
        
        updateProgressLabel()
    }
    
    private func updateProgressLabel() {
        progressLabel.text = "عدد الصور الملتقطة: \(totalPhotosTaken)"
    }
    
    // MARK: - Fetch Data
    private func fetchStudentData() {
        StudentService.shared.fetchCurrentStudent { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let student):
                    self?.currentStudent = student
                    self?.studentNameLabel.text = "الاسم: \(student.name)"
                case .failure(_):
                    self?.studentNameLabel.text = "يرجى تسجيل الدخول"
                }
            }
        }
    }
    
    // MARK: - Camera Setup
    private func setupCamera() {
        cameraManager.delegate = self
        cameraManager.setupCamera(in: cameraContainerView)
        cameraManager.startSession()
    }
    
    // MARK: - Actions
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        confirmButton.isEnabled = false
        photosToTakeInBatch = 5
        takeNextPhoto()
    }
    
    private func takeNextPhoto() {
        guard photosToTakeInBatch > 0 else {
            DispatchQueue.main.async {
                self.confirmButton.isEnabled = true
            }
            return
        }
        cameraManager.takePhoto()
    }
}

// MARK: - CameraManagerDelegate
extension StudentViewController: CameraManagerDelegate {
    func didCaptureImage(_ image: UIImage) {
        guard let student = currentStudent else { return }
        
        // 1. Save Image
        ImageStorageManager.shared.saveImage(image, forStudentId: student.studentId)
        
        // 2. Update UI
        DispatchQueue.main.async {
            self.totalPhotosTaken += 1
            self.updateProgressLabel()
        }
        
        // 3. Continue batch
        photosToTakeInBatch -= 1
        
        if photosToTakeInBatch > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.takeNextPhoto()
            }
        } else {
            DispatchQueue.main.async {
                self.confirmButton.isEnabled = true
            }
        }
    }
}
