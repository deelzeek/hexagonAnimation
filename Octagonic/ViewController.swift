//
//  ViewController.swift
//  Octagonic
//
//  Created by Deel Usmani on 15/03/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var octagon: Octagonic?
    //var convertedRectView: CGRect!
   
    @IBOutlet weak var animationView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()

        //convertedRectView = viewUnder.convert(animationView.frame, to: self.view)

        let img = UIImageView(image: UIImage(named: "buxoro.jpg"))
        
        self.view.backgroundColor = UIColor.white
        octagon = Octagonic(view: self.animationView, image: img, color: UIColor.white, offset: 0)
        octagon?.animateOctagon(duration: 3)
    }
    

  


}
