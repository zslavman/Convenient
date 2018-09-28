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
		case JSON		= "JSON фотоальбома"
		case PRIVAT		= "ПриватБанк курс"
		case GALLERY	= "Gallery"
	}

	public let description:String = "В меню tableView собраны различные тестовые подпрограммы:\n\(menuItems.JSON.rawValue) - получение JSONки с моего сайта и парсинг ее; \n\(menuItems.PRIVAT.rawValue) - JSONкa курса валют ПриватБанка"
	
	
	public let menuArr:Array<String> = [
		menuItems.JSON.rawValue,
		menuItems.PRIVAT.rawValue,
		menuItems.GALLERY.rawValue
	]
	
	public let json_link:String = "http://zslavman.esy.es/imgdb/index.json"
	public let json_privatBank:String = "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5"
	
}


