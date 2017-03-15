//
//  AnimationViewController.swift
//  Octagonic
//
//  Created by Deel Usmani on 15/03/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
    
    var octagon: Octagonic?
    var pickedImage: UIImage?
    var animTime: TimeInterval?
    //var convertedRectView: CGRect!
    
    @IBOutlet weak var animationView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //convertedRectView = viewUnder.convert(animationView.frame, to: self.view)
        
        let img = UIImageView(image: pickedImage ?? UIImage(named: "buxoro.jpg"))
        
        self.view.backgroundColor = UIColor.white
        octagon = Octagonic(view: self.animationView, image: img, color: UIColor.white, offset: 0)
        octagon?.animateOctagon(duration: animTime ?? 1)
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
