//
//  CDHelper.swift
//  PokeGo
//
//  Created by pratik on 06/04/17.
//  Copyright © 2017 Purteeek. All rights reserved.
//

import CoreData
import UIKit

func makeAllPokemons() {
    makePokemon(name: "Pikachu", withThe: "pikachu-2")
    makePokemon(name: "Abra", withThe: "abra")
    makePokemon(name: "Bulbasaur", withThe: "bullbasaur")
    makePokemon(name: "Bellsprout", withThe: "bellsprout")
    makePokemon(name: "Caterpie", withThe: "caterpie")
    makePokemon(name: "Charmander", withThe: "charmander")
    makePokemon(name: "Jigglypuff", withThe: "jigglypuff")
    makePokemon(name: "Mewoth", withThe: "meowth")
    makePokemon(name: "Psyduck", withThe: "psyduck")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
}

func makePokemon(name: String, withThe imageName: String) {
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageName
}

func bringAllPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            makeAllPokemons()
            return bringAllPokemons()
        }
        return pokemons
        
    } catch {
        print("We were not able to get pokemon from Core Data")
        
    }
    return []
    
}

func getAllCaughtPokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught > %d", 0)
    
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {
        print("Error")
    }
    return []
}

func getAllUncaughPokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught == %d", 0)
    
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {
        print("Error")
    }
    return []
}
