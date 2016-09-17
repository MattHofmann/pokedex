//
//  ViewController.swift
//  Pokedex
//
//  Created by Matthias Hofmann on 16.09.16.
//  Copyright © 2016 MatthiasHofmann. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    // MARK: IBOutlets
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegates
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        // change search button to 'done'
        searchBar.returnKeyType = UIReturnKeyType.done
        // ParsePokemonCSV
        parsePokemonCSV()
        // start playing the audio
        initAudio()
        
    }
    
    
    // Prepare the audio
    func initAudio() {
        // path to audio file
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
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
            let poke: Pokemon!
            // searchMode
            if inSearchMode {
                // display filtered cells
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)

            } else {
                // display all cells
                poke = pokemon[indexPath.row]
                // set cell
                cell.configureCell(poke)
            }

            
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
        
        if inSearchMode {
            return filteredPokemon.count
        }
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
    
    // MARK: IBActions
    
    // Method the toggles the music
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    // MARK: SearchBar Methods
    
    // called when a keystroke in searchBar is made
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchMode
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            // hide keyboard
            view.endEditing(true)
        } else {
            inSearchMode = true
        }
        // lowercase text
        let lower = searchBar.text!.lowercased()
        // filter pokemonList for Pokemonname, based on searchBar text
        filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
        // repopulate collectionView with new data
        collection.reloadData()
    }
    
    // MARK: Keyboard
    
    // hides keyboard when searchbutton is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

