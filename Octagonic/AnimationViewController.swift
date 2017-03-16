//
//  AnimationViewController.swift
//  Octagonic
//
//  Created by Deel Usmani on 15/03/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import UIKit
/**
 *AnimationViewController* is a simple viewcontroller that shows fading and bordering animation over picked image.
 */
class AnimationViewController: UIViewController {
    
    var octagon: Octagonic?
    var pickedImage: UIImage?
    var animTime: TimeInterval?
    var vW: CGFloat?
    var vH: CGFloat?
    //var convertedRectView: CGRect!
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet var animViewHeight: NSLayoutConstraint!
    
    @IBOutlet var animViewWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        vW = screenSize.width
        vH = screenSize.height
        
        //convertedRectView = viewUnder.convert(animationView.frame, to: self.view)
        
        let img = UIImageView(image: pickedImage ?? UIImage(named: "buxoro.jpg"))
        
        self.view.backgroundColor = UIColor.white
        octagon = Octagonic(view: self.animationView, image: img, color: UIColor.white, offset: 0)
        octagon?.animateOctagon(duration: animTime ?? 1)
    }
    /**
     *back* action dismisses current view controller
     - Parameter sender: it can be Any object
     */
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            switch orient {
            case .portrait:
                print("portrait")
                self.applyPortraitConstraints()
                break
            default:
                print("land")
                self.applyLandscapeConstraints()
                break
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation finished")
        })
        
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    
    func applyPortraitConstraints() {
        self.animViewHeight.constant = vH!/2
        self.animViewWidth.constant = vW!
    }
    
    func applyLandscapeConstraints() {
        self.animViewHeight.constant = vW!
        self.animViewWidth.constant = vH!/2
    }
    
    

}
