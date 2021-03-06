//
//  Octagonic.swift
//  Octagonic
//
//  Created by Deel Usmani on 15/03/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import Foundation
import UIKit


private extension CGFloat {
    //radians will be used for to create polygons
    func radians() -> CGFloat {
        let b = CGFloat(M_PI) * (self/180)
        return b
    }
}

/**
 *Octagonic* is an object to create animation of octagon over UIImageView
 ### Usage Example: ###
 ````
    var octagon: Octagonic?
    var pickedImage: UIImage?
    var animationView : UIView?
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        ...
        let img = UIImageView(image: pickedImage ?? UIImage(named: "someImage.jpg"))
        octagon = Octagonic(view: self.animationView, image: img, color: UIColor.white, offset: 0)
        octagon?.animateOctagon(duration: animTime ?? 1)
    }
 }

 ````
 - SeeAlso: `requests(_:completion)`
 - Precondition: UIImageView should not be nil. Preferably, create a separate not-nil UIView.
 - Parameter completion: Handler to make something with a return value
 - Returns: void
 */
class Octagonic {
    
    //Values of UIView
    var octagonView:CAShapeLayer?
    var viewLayer: UIView?
    var originX: CGFloat?
    var originY: CGFloat?
    var width: CGFloat?
    var height: CGFloat?
    var img: UIImageView?
    var realScreen: CGRect?
    var midX: CGFloat?
    var midY: CGFloat?

    
    init(view: UIView, image: UIImageView, color: UIColor, offset: CGFloat) {
        
        let screenSize = UIScreen.main.bounds
        let vW = screenSize.width
        let vH = screenSize.height
        
        /*  Weirdness starts here.
            Here, I encountered a little problem of coordinate changes.
            When you change Size Classes in device setting in storyboard, UIView's width doesn't change by variety of devices. The height is configured to be 50% of SuperView.height and it works.
            You can try to recreate what I said by uncommenting and assigning value to midX, width and height. And to go in storyb and try to change device screen and run in emulator or whatever.
         */
        viewLayer = view
        realScreen = view.convert(view.frame, to: UIApplication.shared.keyWindow)
        originX = realScreen?.origin.x
        originY = realScreen?.origin.y
        midX = vW/2 //realScreen?.midX
        midY = realScreen?.midY
        width = vW //realScreen?.width
        height = vH/2 //realScreen?.height
        
        img = image
        
            
        reshapePhoto(image: img!, view: viewLayer!)
        drawPolygon(view: viewLayer!, color: color, offset: offset, sides: 6)
        drawOctoBorders(view: viewLayer!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Not initialized")
    }
    /**
     *reshapePhoto* function changes a UIImageView to fit into UIView the way we want it to do.
     - Parameter view: it should be not-nil UIView
     - Parameter image: it should be not-nil image
     */
    private func reshapePhoto(image: UIImageView, view: UIView) {
        image.frame = CGRect(x: self.originX!, y: self.originY!, width: width!, height: self.height!)
        //We add modified image to UIView
        view.layer.addSublayer(image.layer)
    }
    /**
     *drawPolygon* function creates a CALayer (octagon in our case) and uses that layer as a mask to UIView.
     - Parameter view: it should be not-nil UIView
     - Parameter color: any UIColor
     - Parameter offset: offset
     - Parameter sides: amount of sides. We can create not only octagon. Surprise!
     */
    private func drawPolygon(view: UIView, color: UIColor, offset: CGFloat, sides: Int) {
        let polyLayer = polygonLayer(x: midX!,y: midY!,radius: (width!/3), sides: sides, color: UIColor.white, offset: offset)
        view.layer.mask = polyLayer
        
    }
    /**
     *drawOctoBorders* function creates a CALayer (octagon in our case) and prepares it for animation.
     - Parameter view: it should be not-nil UIView
     */
    private func drawOctoBorders(view: UIView) {
        let path = polygonPath(x: self.midX!, y: self.midY!, radius: (self.width!/3 - 5), sides: 6, offset: 0)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        octagonView = CAShapeLayer()
        octagonView?.path = path
        octagonView?.fillColor = UIColor.clear.cgColor
        octagonView?.strokeColor = UIColor.red.cgColor
        octagonView?.lineWidth = 10.0;
        
        // We don't draw the octagon initially
        octagonView?.strokeEnd = 0.0
        
        view.layer.addSublayer(octagonView!)
        
    }
    
    /**
     *animateOctagon* function creates a CALayer (octagon in our case) and prepares it for animation.
     - Parameter duration: TimeInterval (Double) is a duration of animation.
     */
    func animateOctagon(duration: TimeInterval) {
        
        // Set initial color of octa
        octagonView?.fillColor = UIColor.white.cgColor
        
        // We want to wait for animation ending for callback
        CATransaction.begin()
        
        // We want to animate the strokeEnd property of the octagonLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        let fade = CABasicAnimation(keyPath:"opacity")
        
        // Set the animation duration appropriately
        animation.duration = duration
        fade.duration = duration
        
        // Animate from 0 (no octagon) to 1 (full octagon)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        
        fade.fromValue = 0.0
        fade.toValue = 0.5
        
        // Do a linear animation
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.autoreverses = true
        animation.repeatCount = 1
        
        // Callback function
        CATransaction.setCompletionBlock {
            // Set clear color after animation is finished
            self.octagonView?.fillColor = UIColor.clear.cgColor
        }
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        fade.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        fade.repeatCount = 1
        fade.autoreverses = true
        
        
        // Set the octagonLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        octagonView?.strokeEnd = 1.0
        
        
        
        // Do the actual animation
        octagonView?.add(animation, forKey: "animateOctagon")
        octagonView?.add(fade, forKey: "appear")
        
        //Commit CATransaction
        CATransaction.commit()
    }

    /**
     *polygonPath* function is where the *magic* happens. It is used to create path for 
     polygon creation.
     - Parameter x: x-axis value of the center.
     - Parameter y: y-axis value of the center.
     - Parameter radius: radius from the center.
     - Parameter sides: Amount of sides.
     - Parameter offset: Offset
     */

    private func polygonPath(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, offset: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let points = polygonPointArray(sides: sides,x: x,y: y,radius: radius, offset: offset)
        let cpg = points[0]
        path.move(to: cpg)
        for p in points {
            path.addLine(to: p)
        }
        path.closeSubpath()
        return path
    }
    /**
     *polygonLayer* function creates CAShapeLayer, in our case, for mask layer over UIImageView in UIView.
     - Parameter x: x-axis value of the center.
     - Parameter y: y-axis value of the center.
     - Parameter radius: radius from the center.
     - Parameter sides: Amount of sides.
     - Parameter color: UIColor value.
     - Parameter offset: Offset
     */

    private func polygonLayer(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor, offset:CGFloat) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.path = polygonPath(x: x, y: y, radius: radius, sides: sides, offset: offset)
        shape.fillColor = color.cgColor
        return shape
        
    }
    /**
     *polygonPointArray* function returns an array of CFPoints, or polygons' corners coordinates more precisely.
     - Parameter x: x-axis value of the center.
     - Parameter y: y-axis value of the center.
     - Parameter radius: radius from the center.
     - Parameter sides: Amount of sides.
     - Parameter offset: Offset
     */

    private func polygonPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,offset:CGFloat)->[CGPoint] {
        let angle = (360/CGFloat(sides)).radians()
        let cx = x // x origin
        let cy = y // y origin
        let r = radius // radius of circle
        var i = 0
        var points = [CGPoint]()
        while i <= sides {
            let xpo = cx + r * cos(angle * CGFloat(i) - offset.radians())
            let ypo = cy + r * sin(angle * CGFloat(i) - offset.radians())
            points.append(CGPoint(x: xpo, y: ypo))
            i += 1
        }
        return points
    }
    
}
