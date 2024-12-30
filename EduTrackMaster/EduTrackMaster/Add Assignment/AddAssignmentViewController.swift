//
//  AddAssignmentViewController.swift
//  EduTrack Master
//
//  Created by ucf 2 on 16/12/2024.
//

import UIKit

class AddAssignmentViewController: BaseEduViewController {

        @IBOutlet weak var titleTF: UITextField!
        @IBOutlet weak var sectionTf: UITextField!
        @IBOutlet weak var otherTf: UITextField!
        @IBOutlet weak var notifySwitcch: UISwitch!
        @IBOutlet weak var StartTiming: UIDatePicker!
        
        var lecture = [Assignments]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            notifySwitcch.isOn = true
            configureTapGesture()
            // Do any additional setup after loading the view.
        }
        
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // Configure the tap gesture to hide the keyboard
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
        
         func saveData()
        {
            guard let title = titleTF.text, !title.isEmpty,
                  let section = sectionTf.text, !section.isEmpty,
                  let other = otherTf.text
            else {
                showAlert(title: "Error", message: "Please fill in all fields.")
                return
            }
            
            
            let date = StartTiming.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a" // Customize format as needed
            let strdate = dateFormatter.string(from: date)
            let currentdate = dateFormatter.string(from: Date())
            let id = generateCustomerId()
            
            let rec = Assignments(
                id: "\(id)",
                title: title,
                section: section,
                date: strdate,
                startdate: currentdate,
                other: other
            )
            saveCreateSaleDetail(rec)
            if notifySwitcch.isOn {
                    scheduleNotification(for: title, at: date)
                }
            
        }
        
    func saveCreateSaleDetail(_ order: Assignments) {
        var orders = UserDefaults.standard.object(forKey: "Assignment") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Optional: For readable JSON in console
            let data = try encoder.encode(order)
            
            // Debug print statement
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Assignment to save:\n\(jsonString)")
            }
            
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "Assignment")
            clearTextFields()
        } catch {
            print("Error encoding assignment: \(error.localizedDescription)")
        }
        showAlert(title: "Success", message: "The assignment has been successfully saved.")
    }


        
        func scheduleNotification(for title: String, at date: Date) {
            let notificationCenter = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Upcoming Assignment"
            content.body = "Your assignment titled '\(title)' is scheduled to submitt in 10 minutes."
            content.sound = .default
            
            // Calculate the trigger date (10 minutes before the lecture)
            let triggerDate = date.addingTimeInterval(-10 * 60) // 10 minutes earlier
            let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // Add the notification request
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully!")
                }
            }
        }


        func clearTextFields() {
            titleTF.text = ""
            sectionTf.text = ""
            otherTf.text = ""
        }
        
        @IBAction func SaveButton(_ sender: Any) {
            saveData()
        }
        
        @IBAction func backButton(_ sender: Any) {
            self.dismiss(animated: true)
        }

        @IBAction func scheduleNotifictaionswitch(_ sender: UISwitch) {
            
        }
    }

