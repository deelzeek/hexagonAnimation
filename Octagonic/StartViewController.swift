//
//  StartViewController.swift
//  Octagonic
//
//  Created by Deel Usmani on 15/03/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var animationTimeLabel: UILabel!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var octagonitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        octagonitButton.layer.cornerRadius = 7
        chooseImageButton.layer.cornerRadius = 7
    }

    @IBAction func chooseImageAction(_ sender: Any) {
    
    }
  
    @IBAction func octagonItAction(_ sender: Any) {
        performSegue(withIdentifier: "octagonifySegue" , sender: nil)
    }
    
    @IBAction func sliderValueChanges(_ sender: UISlider) {
        let output = timeSlider.value
        let newValue = 5 * floor((output/5)+0.5)
        timeSlider.value = newValue
        animationTimeLabel.text = "Animation lasts: \(timeSlider.value)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "octagonifySegue" {
            
        }
    }
   
}
