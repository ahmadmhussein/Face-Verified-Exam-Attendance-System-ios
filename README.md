# Face-Verified-Exam-Attendance-System-ios
A secure iOS application for university exam attendance verification using facial capture, built with Swift (UIKit) and Firebase.

A secure university attendance iOS application designed to streamline exam check-ins. The application provides dedicated interfaces for both students and teachers, utilizing device camera hardware to capture face photos for verification and attendance tracking.

## Features

* **Role-Based Access:** Separate, secure user flows for Students, Teachers, and Administrators.
* **Facial Capture System:** Integrates `AVFoundation` for capturing batch photos during student check-ins.
* **Real-Time Data Management:** Fetches and synchronizes student/course data dynamically using Firebase Firestore.
* **Secure Authentication:** User identity verification and secure profile management (e.g., password and name changes) using Firebase Auth.
* **Local & Cloud Storage:** Efficiently manages captured images using the app's local `Documents` directory with Firebase integration.
* **Professional UI/UX:** Clean, academic-themed interface built using MVC architecture, Swift, and `UIKit` Storyboards.

## Tech Stack

* **Language:** Swift 5
* **Architecture:** MVC (Model-View-Controller)
* **UI Framework:** UIKit (Storyboards)
* **Hardware Integration:** AVFoundation (Camera)
* **Backend:** Firebase Authentication, Firebase Firestore

## Setup & Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/YOUR_USERNAME/Face-Verified-Exam-Attendance-System-ios.git](https://github.com/YOUR_USERNAME/Face-Verified-Exam-Attendance-System-ios.git)
