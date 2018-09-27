//
//  Model.swift
//  Convenient
//
//  Created by Zinko Vyacheslav on 18.09.2018.
//  Copyright © 2018 Zinko Vyacheslav. All rights reserved.
//

import Foundation


class Model {
	
	
	
	enum menuItems: String {
		case JSON		= "get JSON"
		case PRIVAT		= "ПриватБанк курс"
		case GALLERY	= "Gallery"

	}
	
	
	public let menuArr:Array<String> = [
		menuItems.JSON.rawValue,
		menuItems.PRIVAT.rawValue,
		menuItems.GALLERY.rawValue
	]
	
	public let json_link:String = "http://zslavman.esy.es/imgdb/index.json"
	public let json_privatBank:String = "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5"
	
}


