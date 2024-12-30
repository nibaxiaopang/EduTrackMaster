//
//  AssignmentHistoryViewController.swift
//  SmartTeach Link
//
//  Created by Unique Consulting Firm on 10/12/2024.
//

import UIKit

class AssignmentHistoryViewController: BaseEduViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var lecture: [Assignments] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let savedData = UserDefaults.standard.array(forKey: "Assignment") as? [Data] {
            let decoder = JSONDecoder()
            lecture = savedData.compactMap { data in
                do {
                    let productsData = try decoder.decode(Assignments.self, from: data)
                    return productsData
                } catch {
                    print("Error decoding product: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        noDataLabel.text = "No History Found" // Set the message
        // Show or hide the table view and label based on data availability
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lecture.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        
        let rec = lecture[indexPath.item]
        cell.titlelb.text = rec.title
        cell.sectionlb.text = rec.section
        cell.datelb.text = rec.startdate
        cell.others.text = rec.other
        if rec.other.isEmpty
        {
            cell.others.text = "No description"
        }
        cell.timeleftlb.text = " : \(rec.date)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the lecture array
            lecture.remove(at: indexPath.row)
            
            // Update the UserDefaults
            let encoder = JSONEncoder()
            do {
                let updatedData = try lecture.map { try encoder.encode($0) }
                UserDefaults.standard.set(updatedData, forKey: "Assignment")
            } catch {
                print("Error updating UserDefaults after deletion: \(error.localizedDescription)")
            }
            
            // Reload the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Check if there's no data left
            if lecture.isEmpty {
                TableView.isHidden = true
                noDataLabel.isHidden = false
            }
        }
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
