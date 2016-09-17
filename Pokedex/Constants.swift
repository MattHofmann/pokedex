//
//  Constants.swift
//  Pokedex
//
//  Created by Matthias Hofmann on 18.09.16.
//  Copyright © 2016 MatthiasHofmann. All rights reserved.
//

import Foundation

// Example-URL:
// http://pokeapi.co/api/v1/pokemon/1/

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

// closure for downloading pokemon details
typealias DownloadComplete = () -> ()
