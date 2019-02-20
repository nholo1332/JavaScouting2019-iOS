//
//  Match.swift
//  JavaScouting2019
//
//  Created by Keegan on 2/11/19.
//  Copyright © 2019 JavaScouts. All rights reserved.
//

import Foundation

struct Match: Codable {
	var matchNum: Int
	var redTeams: [Int]
	var blueTeams: [Int]
	
	func teams() -> [Int] {
		let array = redTeams + blueTeams
		return array
	}
	func getScore(color: String, teams: [ScoutingTeam]?) -> Float {
		var score: Float = 0
		if teams != nil {
			switch color {
			case "red":
				for num in redTeams {
					let team = teams!.first(where: {$0.teamNum == num})
					if let matchScore = team?.scouting.first(where: {$0.matchID == self.matchNum}) {
						score += Float(matchScore.totalPts())
					}
					else {
						score += team?.avgScore(type: "total") ?? 0
					}
					if score == 0 {
						print("could not find data on team \(num)")
					}
				}
			case "blue":
				for num in blueTeams {
					let team = teams!.first(where: {$0.teamNum == num})
					if let matchScore = team?.scouting.first(where: {$0.matchID == self.matchNum}) {
						score += Float(matchScore.totalPts())
					}
					else {
						score += team?.avgScore(type: "total") ?? 0
					}
					if score == 0 {
						print("could not find data on team \(num)")
					}
				}
			default:
				print("unknown alliance color")
			}
		}
		return score
	}
	func getWinner(teams: [ScoutingTeam]?) -> String {
		var result: String = ""
		if teams != nil {
			let redScore = getScore(color: "red", teams: teams)
			let blueScore = getScore(color: "blue", teams: teams)
			if blueScore > redScore {
				result = "Blue"
			}
			else if redScore > blueScore {
				result = "Red"
			}
			else {
				result = "Tie"
				print("Red scored \(redScore), while Blue scored \(blueScore)")
			}
		}
		return result
	}
	func getMatchResults(teams: [ScoutingTeam]?) -> [String: Any] {
		var results: [String: Any]!
		var result: String = ""
		var redScore: Float = 0
		var blueScore: Float = 0
		if teams != nil {
			redScore = getScore(color: "red", teams: teams)
			blueScore = getScore(color: "blue", teams: teams)
			result = getWinner(teams: teams)
		}
		results = [
			"red": redScore,
			"blue": blueScore,
			"result": result
		]
		return results
	}
}
