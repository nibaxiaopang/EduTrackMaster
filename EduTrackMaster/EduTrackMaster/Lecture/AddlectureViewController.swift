import UIKit
import UserNotifications

class AddlectureViewController: BaseEduViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var sectionTf: UITextField!
    @IBOutlet weak var otherTf: UITextField!
    @IBOutlet weak var notifySwitch: UISwitch!
    @IBOutlet weak var startTiming: UIDatePicker!

    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!

    var isMonday = false
    var isTuesday = false
    var isWednesday = false
    var isThursday = false
    var isFriday = false
    var isSaturday = false
    var isSunday = false

    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationPermissions()
        configureTapGesture() 
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

    var lecture = [Lectures]()

    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    @IBAction func mondayCheckbox(_ sender: UIButton) {
        isMonday = !isMonday
        if isMonday {
            mondayButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            mondayButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }

    @IBAction func tuesdayCheckbox(_ sender: UIButton) {
        isTuesday = !isTuesday
        if isTuesday {
            tuesdayButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            tuesdayButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }

    @IBAction func wednesdayCheckbox(_ sender: UIButton) {
        isWednesday = !isWednesday
        if isWednesday {
            wednesdayButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            wednesdayButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }

    @IBAction func thursdayCheckbox(_ sender: UIButton) {
        isThursday = !isThursday
        if isThursday {
            thursdayButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            thursdayButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }

    @IBAction func fridayCheckbox(_ sender: UIButton) {
        isFriday = !isFriday
        if isFriday {
            fridayButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            fridayButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }

    @IBAction func saturdayCheckbox(_ sender: UIButton) {
        isSaturday = !isSaturday
        if isSaturday {
            saturdayButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            saturdayButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }

    @IBAction func sundayCheckbox(_ sender: UIButton) {
        isSunday = !isSunday
        if isSunday {
            sundayButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            sundayButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }

    func saveData() {
        guard let title = titleTF.text, !title.isEmpty,
              let section = sectionTf.text, !section.isEmpty,
              let other = otherTf.text else {
            presentAlert(title: "Incomplete Details", message: "All fields are required. Please fill in each field.")
            return
        }

        let date = startTiming.date
        guard date > Date() 
        else {
            presentAlert(title: "Invalid Date", message: "Please select a future date for the lecture.")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let formattedDate = dateFormatter.string(from: date)
        let lecture = Lectures(
            id: UUID().uuidString,
            title: title,
            section: section,
            date: formattedDate, startdate: "",
            monday: isMonday,
            tuesday: isTuesday,
            wednesday: isWednesday,
            thursday: isThursday,
            friday: isFriday,
            saturday: isSaturday,
            sunday: isSunday,
            other: other
        )
        print("Lecture Details: \(lecture)")

        saveCreateSaleDetail(lecture)
        if notifySwitch.isOn {
            scheduleNotifications(for: title, at: date)
        }
    }

    func saveCreateSaleDetail(_ lecture: Lectures) {
        var lectures = UserDefaults.standard.object(forKey: "lectures") as? [Data] ?? []
        do {
            let encodedLecture = try JSONEncoder().encode(lecture)
            lectures.append(encodedLecture)
            UserDefaults.standard.set(lectures, forKey: "lectures")
            clearTextFields()
            presentAlert(title: "Success", message: "Your lecture has been scheduled successfully!")
        } catch {
            print("Encoding error: \(error.localizedDescription)")
        }
        print("Lecture Details: \(lecture)")
    }

    func scheduleNotifications(for title: String, at date: Date) {
        let daysSelected = [
            (isMonday, Calendar.current.date(byAdding: .day, value: 0, to: date), "Monday"),
            (isTuesday, Calendar.current.date(byAdding: .day, value: 1, to: date), "Tuesday"),
            (isWednesday, Calendar.current.date(byAdding: .day, value: 2, to: date), "Wednesday"),
            (isThursday, Calendar.current.date(byAdding: .day, value: 3, to: date), "Thursday"),
            (isFriday, Calendar.current.date(byAdding: .day, value: 4, to: date), "Friday"),
            (isSaturday, Calendar.current.date(byAdding: .day, value: 5, to: date), "Saturday"),
            (isSunday, Calendar.current.date(byAdding: .day, value: 6, to: date), "Sunday")
        ]
        
        for (isSelected, dayDate, dayName) in daysSelected {
            if isSelected, let dayDate = dayDate {
                let triggerDate = dayDate.addingTimeInterval(-10 * 60) // 10 minutes before the selected time
                let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
                
                let content = UNMutableNotificationContent()
                content.title = "Upcoming Lecture"
                content.body = "Reminder: Your lecture '\(title)' starts soon on \(dayName)."
                content.sound = .default
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Notification error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func clearTextFields() {
        titleTF.text = ""
        sectionTf.text = ""
        otherTf.text = ""
        mondayButton.setImage(UIImage(systemName: "square"), for: .normal)
        tuesdayButton.setImage(UIImage(systemName: "square"), for: .normal)
        wednesdayButton.setImage(UIImage(systemName: "square"), for: .normal)
        thursdayButton.setImage(UIImage(systemName: "square"), for: .normal)
        fridayButton.setImage(UIImage(systemName: "square"), for: .normal)
        saturdayButton.setImage(UIImage(systemName: "square"), for: .normal)
        sundayButton.setImage(UIImage(systemName: "square"), for: .normal)



        
    }

    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveData()
    }

    @IBAction func notificationswitchbutton(_ sender: UISwitch) {
        if notifySwitch.isEnabled {
            // You can keep this method for switching notifications on/off if needed
        }
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
