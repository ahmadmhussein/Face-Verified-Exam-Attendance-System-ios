//
//  FaceCaptureViewController.swift
//  TestGP
//
//  Created by Ahmad on 18/07/2026.
//

import UIKit
import AVFoundation

class FaceCaptureViewController: UIViewController {

    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var studentCardView: UIView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCamera()
        loadStudentData()
    }
    
    func setupUI() {
        cameraContainerView.layer.cornerRadius = 16
        cameraContainerView.clipsToBounds = true
        
        confirmButton.layer.cornerRadius = 12
        
        studentCardView.layer.cornerRadius = 16
        studentCardView.layer.shadowColor = UIColor.black.cgColor
        studentCardView.layer.shadowOpacity = 0.05
        studentCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        studentCardView.layer.shadowRadius = 6
    }
    
    func loadStudentData() {
        studentNameLabel.text = "أحمد حسين"
        studentIdLabel.text = "441987654"
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = cameraContainerView.bounds
            cameraContainerView.layer.insertSublayer(previewLayer, at: 0)
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if previewLayer != nil {
            previewLayer.frame = cameraContainerView.bounds
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        
    }
}
