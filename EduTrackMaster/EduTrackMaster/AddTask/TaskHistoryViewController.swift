import UIKit

class TaskHistoryViewController: BaseEduViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var lecture: [Assignments] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load saved tasks from UserDefaults
        if let savedData = UserDefaults.standard.array(forKey: "task") as? [Data] {
            let decoder = JSONDecoder()
            lecture = savedData.compactMap { data in
                do {
                    let task = try decoder.decode(Assignments.self, from: data)
                    return task
                } catch {
                    print("Error decoding task: \(error.localizedDescription)")
                    return nil
                }
            }
        }
      
        noDataLabel.text = "No History Found" // Set the message
        if lecture.isEmpty {
            TableView.isHidden = true
            noDataLabel.isHidden = false  // Show the label when there's no data
        } else {
            TableView.isHidden = false
            noDataLabel.isHidden = true   // Hide the label when data is available
        }
        
        print(lecture)  // Check if data is loaded
        TableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lecture.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell and cast it to your custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskHistoryTableViewCell
        let rec = lecture[indexPath.row]
        cell.titlelb.text = "Task title: \(rec.title)"
            if !rec.other.isEmpty {
            cell.desclb.text = rec.other
        } else {
            cell.desclb.text = "No description available"
        }
            cell.datelb.text = "Scheduling date: \(rec.startdate)"
        
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            lecture.remove(at: indexPath.row)
            saveUpdatedData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if lecture.isEmpty {
                TableView.isHidden = true
                noDataLabel.isHidden = false
            } else {
                TableView.isHidden = false
                noDataLabel.isHidden = true
            }
        }
    }

    func saveUpdatedData() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(lecture)
            UserDefaults.standard.set(data, forKey: "task")
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }

    @IBAction func btnback(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
