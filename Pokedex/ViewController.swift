//
//  ViewController.swift
//  Pokedex
//
//  Created by Matthias Hofmann on 16.09.16.
//  Copyright © 2016 MatthiasHofmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: IBOutlets
    @IBOutlet weak var collection: UICollectionView!
    

    var pokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        
        parsePokemonCSV()
    }
    
    // Method that parse the pokemon.csv
    func parsePokemonCSV() {
        // path to pokemon.csv
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            // parse CSV rows
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            // for each row get pokeId and name and put it in the pokemon array
            for row in rows {
                
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
        
        
    }

    // MARK: CollectionView Methods

    // Create CollectionViewCells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            // Pokemon obj from array
            let poke = pokemon[indexPath.row]
            // set cell
            cell.configureCell(poke)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // Function if the user taps a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO
    }
    
    // Amount of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    // Number of Sections in CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Define size of CollectionViewCells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
}

