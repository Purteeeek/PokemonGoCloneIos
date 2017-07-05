//
//  PokedexViewController.swift
//  PokeGo
//
//  Created by pratik on 06/04/17.
//  Copyright © 2017 Purteeek. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []

    @IBAction func backToMapButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caughtPokemons = getAllCaughtPokemons()
        
        uncaughtPokemons = getAllUncaughPokemons()
        
        print(uncaughtPokemons.count)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return self.caughtPokemons.count
        }else {
            return self.uncaughtPokemons.count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Caught Pokemons"
            
        }else {
            return "Uncaught Pokemons"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var pokemon : Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.caughtPokemons[indexPath.row]
        }else {
            pokemon = self.uncaughtPokemons[indexPath.row]
        }
        
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageFileName!)
        return cell
    }
    

}
