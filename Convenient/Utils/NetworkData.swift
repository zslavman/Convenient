//
//  NetworkData.swift
//  Convenient
//
//  Created by Zinko Vyacheslav on 19.09.2018.
//  Copyright © 2018 Zinko Vyacheslav. All rights reserved.
//

import Foundation




class NetworkData {
	
	
	public static let share = NetworkData()
	
	private init(){ }
	
	// completion - ф-ция колбэка, которую передаем в этот метод, в скобках @escaping передаваемые параметры в колбэк
//	public func getData(urlString: String, decodableStruct:Decodable.Type, completion: @escaping (Array<Any>) -> Void){
	public func getData<T>(urlString: String, decodableStruct:T, completion: @escaping (Array<Any>) -> Void){
		
		// проверяем рабочий ли урл
		guard let url = URL(string: urlString) else { return }
		
		let session = URLSession.shared
		
		// создаем таск
		let task = session.dataTask(with: url) {
			(data, response, error) in
			
			guard let data = data else { return }
			guard error == nil else { return }
			
			do {
				if decodableStruct is PhotoData.Type {
					let jsonItems = try JSONDecoder().decode([PhotoData].self, from: data)
					completion(jsonItems)
				}
				else if decodableStruct is CurencyExchange.Type{
					let jsonItems = try JSONDecoder().decode([CurencyExchange].self, from: data)
					completion(jsonItems)
				}
				
				print("got new JSON")
			}
			catch {
				print(error.localizedDescription)
			}
		}
		
		// Запускаем таск
		task.resume()
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
