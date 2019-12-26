//
//  ViewController.swift
//  Starfighter
//
//  Created by Arthur BLANC on 26/12/2019.
//  Copyright © 2019 Arthur BLANC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
              self.navigationController?.setNavigationBarHidden(true, animated: animated)
              
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "space.jpeg")!)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func Button(_ sender: Any) {
        self.navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
