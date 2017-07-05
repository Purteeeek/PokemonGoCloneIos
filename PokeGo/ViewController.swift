//
//  ViewController.swift
//  PokeGo
//
//  Created by pratik on 05/04/17.
//  Copyright © 2017 Purteeek. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    //Compass Button
    @IBAction func userLocationUpdatedButtonPress(_ sender: Any) {
        let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
        self.mapView.setRegion(region, animated: true)
    }
    
    var update = 0
    
    var manager = CLLocationManager()
    
    var pokemons : [Pokemon] = []
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        } else {
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            annotationView.image = UIImage(named: pokemon.imageFileName!)
        }
        
        var newFrame = annotationView.frame
        newFrame.size.height = 40
        newFrame.size.width = 40
        annotationView.frame = newFrame
        
        return annotationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.delegate = self
        self.manager.delegate = self
        
        // get all pokemons 
        pokemons = bringAllPokemons()
        
        //Setting our location authorization and Status (Step 1 and also add it to pList)
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
            
            // This is for spawning pokemon which comes in later part panda bhulna mat
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {
                (timer) in
                
                if let coordinate = self.manager.location?.coordinate {
                    
                     let randomPokemon = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                    let pokemon = self.pokemons[randomPokemon]
                    let annotation = PokemonAnnotation(coordinate: coordinate, pokemon: pokemon)
                    
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                    self.mapView.addAnnotation(annotation)
                }
            })
        }
        else {
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    // Step 2 (Adding Location Manager Function and update )
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if update < 4 {
            let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
            self.mapView.setRegion(region, animated: true)
            update += 1 
        } else {
            self.manager.stopUpdatingLocation()
        }
        

        
            
     
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance((view.annotation?.coordinate)!, 150, 150)
        self.mapView.setRegion(region, animated: false)
        
        if let coordinate = self.manager.location?.coordinate {
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coordinate)){
               // print("Pakda")
                
                // load a controller and present a new controller 
                let battle = BattleViewController()
                
                // to create and pass the pokemon 
                let pokemon = (view.annotation as! PokemonAnnotation).pokemon
                battle.pokemon = pokemon
                self.mapView.removeAnnotation(view.annotation!)
                self.present(battle, animated: true, completion: nil)
            }else {
                
                print("Nahi Pakda")
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

