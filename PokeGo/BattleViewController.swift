//
//  BattleViewController.swift
//  PokeGo
//
//  Created by pratik on 06/04/17.
//  Copyright © 2017 Purteeek. All rights reserved.
//

import UIKit
import SpriteKit

class BattleViewController: UIViewController {
    
    var pokemon : Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a constant that has a scene and whenever the view loads you want the scene to be ready
        let scene = BattleScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        // we want to override the view now 
        self.view = SKView()
        
        // self.view.show fps wont work because it by default was not of game view
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        
        scene.pokemon = self.pokemon
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.returnToMapViewController), name: NSNotification.Name("CloseBattle"), object: nil)
    }
    
    func returnToMapViewController() {
    self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
