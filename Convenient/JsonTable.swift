//
//  JsonTable.swift
//  Convenient
//
//  Created by Zinko Vyacheslav on 22.09.2018.
//  Copyright © 2018 Zinko Vyacheslav. All rights reserved.
//

import UIKit


struct PhotoData:Decodable {
	
	
	var index		:Int?
	var view		:String?
	var description	:String?
	var album_name	:String?
	var order		:Int?
	var isActive	:Bool?
	var city		:String?
	//	var geo			:[Dictionary<String, Any>]
	//	var geo			:[String: Any] = try container.decode([String: Any].self, forKey: key)
	
	
	//	"view": "sri_00.jpg",
	//	"description": "Закат 1",
	//	"album_name": "Шри-Ланка",
	//	"order": 3,
	//	"isActive": true,
	//	"city": "Croom",
	//	"geo": [{
	//		"latitude": 29.315768,
	//		"longitude": 42.8041
	//	}]
	
}








class JsonTable: UITableViewController {

	
	private var dataToFillingCells:Array<PhotoData> = []
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Decodable test"
		
		NetworkData.share.getData(urlString: MainView.selF.model.json_link, decodableStruct: PhotoData.self) {
			(responseArray) in
			self.dataToFillingCells = responseArray as! [PhotoData]
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
			
		}
	}
	

	
	

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataToFillingCells.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "json_table_cell", for: indexPath)
		
		// чтоб не заводить отдельный класс для ячейки используем тэги
		let label1_TF = cell.viewWithTag(1) as! UILabel
		label1_TF.text = dataToFillingCells[indexPath.row].album_name
		let label2_TF = cell.viewWithTag(2) as! UILabel
		label2_TF.text = dataToFillingCells[indexPath.row].description
		let label3_TF = cell.viewWithTag(3) as! UILabel
		label3_TF.text = dataToFillingCells[indexPath.row].city
		let label4_TF = cell.viewWithTag(4) as! UILabel
		label4_TF.text = dataToFillingCells[indexPath.row].view

        return cell
    }
	


	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	
	
	
	
	
	
	

}
