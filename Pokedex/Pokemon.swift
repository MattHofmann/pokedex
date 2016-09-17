//
//  Pokemon.swift
//  Pokedex
//
//  Created by Matthias Hofmann on 16.09.16.
//  Copyright © 2016 MatthiasHofmann. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    fileprivate var _description: String!
    fileprivate var _type: String!
    fileprivate var _defense: String!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _attack: String!
    fileprivate var _nextEvolutionText: String!
    fileprivate var _nextEvolutionName: String!
    fileprivate var _nextEvolutionId: String!
    fileprivate var _nextEvolutionLevel: String!
    fileprivate var _pokemonURL: String!
    
    // getter
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    // init
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        
    }
 
    //
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        // Alamofire GET request
        Alamofire.request(_pokemonURL).responseJSON(completionHandler: { response in
            // put whole JSON in dictionary
            if let dict = response.result.value as? Dictionary<String,AnyObject> {
                // weight
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                // height
                if let height = dict["height"] as? String {
                    self._height = height
                }
                // attack
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                // defense
                if let defense = dict["attack"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print("PokemonSTATS:")
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                // type
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                // description
                if let  descArr = dict["descriptions"] as? [Dictionary<String,String>], descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { response in
                            if let descDict = response.result.value as? Dictionary<String,AnyObject> {
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                            completed()
                        })
                        
                    } else {
                        self._description = ""
                    }
                }
                
                // evolutions
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] , evolutions.count > 0 {
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        
                        if nextEvolution.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvolution
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvolutionId = newString.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvolutionId
                                
                                if let levelExist = evolutions[0]["level"] {
                                    if let level = levelExist as? Int {
                                        self._nextEvolutionLevel = "\(level)"
                                    }
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                }
            }
            completed()
        })
    }
}
