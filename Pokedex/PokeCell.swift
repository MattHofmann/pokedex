//
//  PokeCell.swift
//  Pokedex
//
//  Created by Matthias Hofmann on 17.09.16.
//  Copyright © 2016 MatthiasHofmann. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    // IBOutlets
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    // rounded corners
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    // configureCell
    func configureCell(pokemon: Pokemon) {
        
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalized
        thumbImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
}
