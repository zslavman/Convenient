//
//  ViewController.swift
//  Convenient
//
//  Created by Zinko Vyacheslav on 18.09.2018.
//  Copyright © 2018 Zinko Vyacheslav. All rights reserved.
//

import UIKit

class MainView: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	
	@IBOutlet weak var menuTable: UITableView!
	
	public static var selF:MainView!
	public var model = Model()

	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		MainView.selF = self
		title = "ЯП!"
	
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
			navigationItem.largeTitleDisplayMode = .automatic
		}
		// если возвращатся свайпом вправо, то полезно это
		self.extendedLayoutIncludesOpaqueBars = true
	}
	
	
	
	
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Меню"
		}
		return "Секция 2"
	}
	
	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 0 {
			return model.description
		}
		return "Описание для секции 2"
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return model.menuArr.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "mmCell", for: indexPath) // as! MainMenuCell
		let section = indexPath.section

		if section == 0 {
			cell.textLabel?.text = model.menuArr[indexPath.row]
		}
		
		
		return cell
	}



	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let section = indexPath.section
		if section == 0 {
			switch model.menuArr[indexPath.row]{
			case Model.menuItems.JSON.rawValue:
				performSegue(withIdentifier: "segue_in_JsonTable", sender: nil)
			case Model.menuItems.PRIVAT.rawValue:
				performSegue(withIdentifier: "segue_in_PrivatBank", sender: nil)
			default:
				print("Can't find appropriate segue!")
//				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//					tableView.deselectRow(at: indexPath, animated: true)
//				}
				perform(#selector(viewWillAppear), with: nil, afterDelay: 1)
			}
		}
	}

	

	
	
	
	override func viewWillAppear(_ animated: Bool) {
	
		if let indexPath = menuTable.indexPathForSelectedRow {
			menuTable.deselectRow(at: indexPath, animated: true)
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

