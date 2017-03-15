//
//  StartViewController.swift
//  Octagonic
//
//  Created by Deel Usmani on 15/03/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var animationTimeLabel: UILabel!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var octagonitButton: UIButton!
    @IBOutlet weak var chosenImageStatus: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    var pickedImage: UIImage?
    var animationTime: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        octagonitButton.layer.cornerRadius = 7
        chooseImageButton.layer.cornerRadius = 7
        imagePicker.delegate = self
    }
    /**
     *chooseImageAction* is a button to trigger image picker
     - Parameter sender: it can be Any object
     */
    @IBAction func chooseImageAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// MARK! - UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //imageView.contentMode = .ScaleAspectFit
            pickedImage = chosenImage
            self.chosenImageStatus.text = "Loaded"
            //print(info)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
    }
    /**
     *octagonItAction* triggers user to the AnimationVC
     - Parameter sender: it can be Any object
     */
    @IBAction func octagonItAction(_ sender: Any) {
        performSegue(withIdentifier: "octagonifySegue" , sender: nil)
    }
    /**
     *sliderValueChanges* is needed to update current value and show it to the user
     - Parameter sender: it can be Any object
     */
    @IBAction func sliderValueChanges(_ sender: UISlider) {
        //We get currect value of the slider
        let output = timeSlider.value
        //We make steps with interval of 5
        let newValue = 5 * floor((output/5)+0.5)
        //We assign new value to the slider
        timeSlider.value = newValue
        // Update text of current state of the slider
        animationTimeLabel.text = "Animation lasts: \(timeSlider.value) sec"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "octagonifySegue" {
            //We have navcontroller on our way to AnimationVC
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! AnimationViewController
            targetController.pickedImage = self.pickedImage
            targetController.animTime = Double(self.timeSlider.value)
            
        }
    }
   
}
