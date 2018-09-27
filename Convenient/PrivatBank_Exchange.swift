//
//  PrivatBank_Exchange.swift
//  Convenient
//
//  Created by Zinko Vyacheslav on 24.09.2018.
//  Copyright © 2018 Zinko Vyacheslav. All rights reserved.
//


import UIKit
import AVFoundation


struct CurencyExchange:Decodable {
	
	var ccy:String?
	var base_ccy:String?
	var buy:String?
	var sale:String?
	
	//	"ccy":"RUR",
	//	"base_ccy":"UAH",
	//	"buy":"0.28000",
	//	"sale":"0.32000"
}







class PrivatBank_Exchange: UITableViewController {

	
	private var current_course:Array<CurencyExchange> = []
	private let firmColor = #colorLiteral(red: 0.2705882353, green: 0.5411764706, blue: 0.1843137255, alpha: 1)
	private var tapCount = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "ПриватБанк"
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//		 self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		// добавляем кнопку справа для теста системных звуков
		let camera = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(playSystemSound))
		self.navigationItem.rightBarButtonItem = camera

		
		// цвет заглавья навбара
		let titleStyle = [NSAttributedStringKey.foregroundColor: firmColor]
		navigationController?.navigationBar.titleTextAttributes = titleStyle
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.largeTitleTextAttributes = titleStyle
		}
		
		fillTable()
		
		// дергалка за которую дергаешь а оно обновляется! хопа!
		refreshControl = UIRefreshControl()
		refreshControl?.backgroundColor = firmColor
		refreshControl?.tintColor = .white
		refreshControl?.addTarget(self, action: #selector(refreshControlUpdate), for: UIControlEvents.valueChanged)
		
	}
	
	
	
	
	
	
	
	private func fillTable(){
		
		NetworkData.share.getData(urlString: MainView.selF.model.json_privatBank, decodableStruct: CurencyExchange.self) {
			(received_json) in
			self.current_course = received_json as! [CurencyExchange]
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
				// вибрация при получении джейсонки
				AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
				self.refreshControl?.endRefreshing()
			}
		}
	}

	
	
	
	



	@objc private func refreshControlUpdate(){
		current_course = []
		tableView.reloadData()
		
		fillTable()
	}



    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Курс валют на сегодня:"
		}
		return "Секция 2"
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return current_course.count
    }

	
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "privatBank_table_cell", for: indexPath)
		
		let bc = current_course[indexPath.row].buy ?? "0"
		let buyCourse = String(format: "%.2f", Double(bc)!)

		let sc = current_course[indexPath.row].sale ?? "0"
		let saleCourse = String(format: "%.2f", Float(sc)!)
		
		//обращаемся к текстовым лейблам кастомной ячейки чере tag'и
		let label1_TF = cell.viewWithTag(1) as! UILabel
		label1_TF.text = current_course[indexPath.row].ccy ?? "nil" + " / " + current_course[indexPath.row].base_ccy!
		
		let label2_TF = cell.viewWithTag(2) as! UILabel
		label2_TF.text = buyCourse + " - " + saleCourse
		
		// стили
		if (indexPath.row % 2 != 0) {
			cell.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
		}
		
		tableView.separatorColor = firmColor
		return cell
    }


	
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(false)
		
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
		if #available(iOS 11.0, *) {
			self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
		}
		
	}
	
	
	
	
	
	// будет работать только на устройствах с технологией Taptick
	@objc private func playSystemSound(){
		
		tapCount += 1
		print("Running \(tapCount)")
		
		switch tapCount {
		case 1:
			let generator = UINotificationFeedbackGenerator()
			generator.notificationOccurred(.error)
			
		case 2:
			let generator = UINotificationFeedbackGenerator()
			generator.notificationOccurred(.success)
			
		case 3:
			let generator = UINotificationFeedbackGenerator()
			generator.notificationOccurred(.warning)
			
		case 4:
			let generator = UIImpactFeedbackGenerator(style: .light)
			generator.prepare()
			generator.impactOccurred()
		case 5:
			let generator = UIImpactFeedbackGenerator(style: .medium)
			generator.prepare()
			generator.impactOccurred()
			
		case 6:
			let generator = UIImpactFeedbackGenerator(style: .heavy)
			generator.prepare()
			generator.impactOccurred()
			
		default:
			let generator = UISelectionFeedbackGenerator()
			generator.selectionChanged()
			tapCount = 0
		}
	}
	
	
	
	
	

}
