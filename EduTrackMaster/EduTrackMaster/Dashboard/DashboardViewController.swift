//
//  DashboardViewController.swift
//  EduTrack Master
//
//  Created by UCF 1 on 10/12/2024.
//

import UIKit

class DashboardViewController: BaseEduViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addlecture(_ sender: Any) {
        
    
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddlectureViewController") as! AddlectureViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        
        }
    @IBAction func viewlecture(_ sender: Any) {
        
    
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LectureHistoryViewController") as! LectureHistoryViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        
        }
    @IBAction func addassignment(_ sender: Any) {
        
    
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        
        }
    @IBAction func viewassigment(_ sender: Any) {
        
    
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AssignmentHistoryViewController") as! AssignmentHistoryViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        
        }
    @IBAction func addtask(_ sender: Any) {
        
    
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        
        }
    @IBAction func viewtaskhistory(_ sender: Any) {
        
    
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TaskHistoryViewController") as! TaskHistoryViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        
        }
    @IBAction func btnsetting(_ sender: Any) {
        
    
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        
        }

}
