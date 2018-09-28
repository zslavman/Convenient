//
//  JsonTable.swift
//  Convenient
//
//  Created by Zinko Vyacheslav on 22.09.2018.
//  Copyright © 2018 Zinko Vyacheslav. All rights reserved.
//

import UIKit
import MapKit


struct PhotoData:Decodable {

	var index		:Int?
	var view		:String?
	var description	:String?
	var album_name	:String?
	var order		:Int?
	var isActive	:Bool?
	var city		:String?
	var geo			:[Geo]
	var reserv		:String? // тут будет подсчитанная инфа
	

//	enum CustomerKeys: CodingKey {
//		case view, description, album_name, city
//		case index, order
//		case isActive
//		case geo
//	}
//
//	init(from decoder: Decoder) throws {
//		let container = try decoder.container (keyedBy: CustomerKeys.self)
//
//		index = try container.decode (Int.self, forKey: .index)
//		view = try container.decode (String.self, forKey: .view)
//		description = try container.decode (String.self, forKey: .description)
//		album_name = try container.decode (String.self, forKey: .album_name)
//		order = try container.decode (Int.self, forKey: .order)
//		isActive = try container.decode (Bool.self, forKey: .isActive)
//		city = try container.decode (String.self, forKey: .city)
//		geo = try container.decode ([String: Any].self, forKey: .geo) // No 'decode' candidates produce the expected contextual result type '[String : Any]'
//	}
	
	
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


struct Geo:Decodable {
	var latitude:Double?
	var longitude:Double?
}







class JsonTable: UITableViewController {

	
	private var dataToFillingCells:Array<PhotoData> = []
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Decodable test"
		
		NetworkData.share.getData(urlString: MainView.selF.model.json_link, decodableStruct: PhotoData.self) {
			(responseArray) in
			self.dataToFillingCells = responseArray as! [PhotoData]
			
			// сортировка
//			self.dataToFillingCells = self.dataToFillingCells.sorted(by: { (a, b) -> Bool in
//				// числовые сортировки
//				return a.index! < b.index! // прямая
//				// return a.index! > b.index! // обратная
//
//				// строковые сортировки
//				// return a.city!.compare(b.city!) == .orderedAscending // прямая
//				// return a.city!.compare(b.city!) == .orderedDescending // обратная
//			})
			self.dataToFillingCells = self.dataToFillingCells.sorted(by: { $0.index! < $1.index! })
			

			// заполняем вычисленный по координатам город и страну
//			for var mItem in self.dataToFillingCells{
//				self.geoTagging(CLLocationDegrees(mItem.geo[0].latitude ?? 0), CLLocationDegrees(mItem.geo[0].longitude ?? 0)){
//					(value) in
//					mItem.reserv = value
//
//					DispatchQueue.main.async {
//						self.tableView.reloadData()
//					}
//				}
//			}
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
			
		}
	}
	

	
	

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
		
		// фотка
		let image1 = cell.viewWithTag(5) as! UIImageView
		image1.image = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1).image(CGSize(width: image1.frame.width, height: image1.frame.height))
		
		// картинка карты
		let image2 = cell.viewWithTag(6) as! UIImageView
		image2.image = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).image(CGSize(width: image2.frame.width, height: image2.frame.height))

		// Geolocation, geo[0] будет всегда
		let lat = String(format: "%.4f", dataToFillingCells[indexPath.row].geo[0].latitude ?? 0)
		let lon = String(format: "%.4f", dataToFillingCells[indexPath.row].geo[0].longitude ?? 0)
		
		let label5_TF = cell.viewWithTag(7) as! UILabel
		label5_TF.text = "Lat: " + lat + " Lon: " + lon
		
		// страна и город, вычесленные по координатам
		let label6_TF = cell.viewWithTag(8) as! UILabel
		label6_TF.text = dataToFillingCells[indexPath.row].reserv
		
		return cell
	}
	
	

	
	
	
	
	
	
	/// Геошняжки
	private func geoTagging(_ lat:CLLocationDegrees, _ lon:CLLocationDegrees, complition: @escaping(String) -> Void) {
		
		let geocoder = CLGeocoder()
		
		geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lon)) {
			(placeMarksArr, error) in
			
			guard error == nil else { return }
			
			var placemark:CLPlacemark!
			var addressString: String = ""
			
			if let placeMarksArr = placeMarksArr {
				
				if placeMarksArr.count > 0 {
					placemark = placeMarksArr[0] as CLPlacemark
				}
				
				// print("isoCountryCode = \(placemark.isoCountryCode ?? "no country code")") // UA
				
				
				// if placemark.subThoroughfare != nil {
				// 		addressString = placemark.subThoroughfare! + " "
				// }
				// if placemark.thoroughfare != nil {
				// 		addressString += placemark.thoroughfare! + ", "
				// }
				//	if placemark.postalCode != nil {
				//		addressString += placemark.postalCode! + " "
				//	}
				//	if placemark.locality != nil {
				//		addressString += placemark.locality! + ", "
				//	}
				if placemark.administrativeArea != nil {
					addressString += placemark.administrativeArea! + ", "
				}
				if placemark.country != nil {
					addressString += placemark.country!
				}
				// if placemark.subAdministrativeArea != nil {
				// 		addressString += placemark.subAdministrativeArea! + ", "
				// }
				print(addressString)
				complition(addressString)
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
}






// MARK: - заливка картинки цветом
extension UIColor {
	func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image {
			rendererContext in
			self.setFill()
			rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
		}
	}
	// использование
	//	let image0.image:UIImageView = UIColor.orange.image(CGSize(width: 128, height: 128))
}





















