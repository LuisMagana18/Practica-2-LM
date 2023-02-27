//
//  Coctel.swift
//  Practica 2
//
//  Created by Luis Angel Magaña on 28/02/23.
//

import Foundation


struct Coctel: Codable{
    let resultado: [Resultado]
}

struct Resultado: Codable{
    let name : String
    let img : String
    let ingredients : String
    let directions : String
    
    
    init(name: String, img: String, ingredients: String, directions: String){
        self.name = name
        self.img = img
        self.ingredients = ingredients
        self.directions = directions
    }
}
