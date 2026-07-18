//
//  SubjectSection.swift
//  TestGP
//
//  Created by Ahmad on 25/05/2026.
//
import Foundation

struct Student {
    let studentId: String
    let name: String
    let major: String
    let email: String
    let facePath: String
}

struct SubjectSection {
    let subjectName: String
    let subjectCode: String
    var students: [Student]
}
