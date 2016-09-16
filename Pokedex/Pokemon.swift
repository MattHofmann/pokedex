//
//  Pokemon.swift
//  Pokedex
//
//  Created by Matthias Hofmann on 16.09.16.
//  Copyright © 2016 MatthiasHofmann. All rights reserved.
//

import Foundation

// Cla
class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    
    // getter
    
    var name: String {
        
        return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    // init
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        
    }
    
}
