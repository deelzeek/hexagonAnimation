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

    @IBAction func chooseImageAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
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
  
    @IBAction func octagonItAction(_ sender: Any) {
        performSegue(withIdentifier: "octagonifySegue" , sender: nil)
    }
    
    @IBAction func sliderValueChanges(_ sender: UISlider) {
        let output = timeSlider.value
        let newValue = 5 * floor((output/5)+0.5)
        timeSlider.value = newValue
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
