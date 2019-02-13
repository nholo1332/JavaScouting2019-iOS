//
//  CompetitionTableViewController.swift
//  JavaScouting2019
//
//  Created by Keegan on 2/12/19.
//  Copyright © 2019 JavaScouts. All rights reserved.
//

import UIKit
import Firebase

class CompetitionTableViewController: UITableViewController {
	
	var competitions: [Competition] = [Competition]()
	var db: Firestore!
        
    override func viewDidLoad() {
        super.viewDidLoad()
		
		refresh()
	}
	
	func refresh() {
		if db != nil {
			getCompetitions()
		}
		else {
			print("Database not initialized. Initializing.")
			db = Firestore.firestore()
			getCompetitions()
		}
	}
	
	func getCompetitions() {
		db.collection("test-competitions").getDocuments() { (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
			} else {
				for document in querySnapshot!.documents {
					let compDoc = document
					let compData = compDoc.data()
					if let newComp = try? JSONSerialization.data(withJSONObject: compData, options: []) {
						var comp: Competition!
						
						comp = try! JSONDecoder().decode(Competition.self, from: newComp)
						comp.compID = compDoc.documentID
						if comp.matches == nil {
							comp.matches = [Match]()
						}
						if comp.teams == nil {
							comp.teams = [ScoutingTeam]()
						}
						self.competitions.append(comp)
						print(comp)
						
					}
					
				}
				self.tableView.reloadData()
			}
			
		}
		
	}

    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = competitions.count
		return count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionCell", for: indexPath)
		let comp = competitions[indexPath.row]
		
		cell.textLabel?.text = comp.compname

        return cell
    }
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let identifier = segue.identifier
		switch identifier {
		case "existingCompetitionToDetail":
			let tab = segue.destination as! UITabBarController
			let nav = tab.viewControllers?.first as! UINavigationController
			let destination = nav.viewControllers.first as! TeamsViewController
			let indexPath = tableView.indexPathForSelectedRow
			
			destination.teams = self.competitions[indexPath!.row].teams
		default:
			print("unknown segue identifier")
		}
    }
    
}
