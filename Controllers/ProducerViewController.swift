//
//  ProducerViewController.swift
//  BeerApp
//
//  Created by Grégoire LARATTE on 28/12/20.
//

import Foundation
import UIKit

class ProducerViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    
    
    
   
    @IBOutlet weak var nameOfProducer: UITextField!
    @IBOutlet weak var imageOfProducer: UIImageView!
    @IBOutlet weak var numberOfBeers: UILabel!
    
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var deleteBtt: UIButton!
    
    var aProducer:Producer?
    
    
    let imgPicker = UIImagePickerController()
    var aModel: Model?
    var aAction: String?
    var name: String?
    var producerImage: UIImage!
    var number: String?
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        nameOfProducer.backgroundColor = UIColor.lightGray
        nameOfProducer.textColor = UIColor.blue

        
        nameOfProducer.text = aProducer?.nameProducer
        
        if nameOfProducer.text == ""{
            deleteBtt.isEnabled = false
            
        }else{
            
            deleteBtt.isEnabled = true
        }
        

  
        //Set up credentials of or  porducer
        nameOfProducer.text = aProducer?.nameProducer
        if aProducer?.logoProducer == nil{
            print("HEMOES ESTADO AQUI")
            let pathToMark = Bundle.main.url(forResource:"defaultPic",withExtension: "png")
            
            aProducer?.logoProducer = UIImage(contentsOfFile: pathToMark!.path)?.pngData()
            
        }
        
        print("88888888888888888")
        print(aProducer?.logoProducer)
        let pathToMark = Bundle.main.url(forResource:"defaultPic",withExtension: "png")
        
        imageOfProducer.image = UIImage(contentsOfFile: pathToMark!.path)

        let num = aProducer?.beersCollect?.count ?? 0
        numberOfBeers.text = "Nº of Beers: \(num)"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.imageOfProducer.addGestureRecognizer(tapGesture)
       
    }
    
    @IBAction func cancelAction(_ sender: Any){
        performSegue(withIdentifier: "unwindSegueFromProducerView", sender: self)//posible error
    }
    
    @IBAction func deleteAction(_ sender: Any){
        
        
        aModel?.producersNamed.removeValue(forKey: aProducer!.nameProducer)
        print("5555555555555")
        print(aModel?.producersNamed)
        aModel?.producers.removeAll()
        aModel?.producers = aModel!.producersNamed.map { (name, producer) in
            return producer
        }
        performSegue(withIdentifier: "unwindSegueFromProducerView", sender: self)//posible error
        
    }

    override public var shouldAutorotate: Bool {
        return false
      }
      override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
      }
      override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
      }
    
    
    @IBAction func acceptAcceptAndReturn(_ sender: Any){
        var allCorrect : Bool = true

        if !checkType(self.nameOfProducer.text!, "word")  {
            
            self.nameOfProducer.textColor = .red
            allCorrect = false
        }
        self.name = self.nameOfProducer.text
        self.number = self.numberOfBeers.text
        if self.producerImage == nil{
            
            let pathToMark = Bundle.main.url(forResource:"defaultPic",withExtension: "png")
            
            self.producerImage = UIImage(contentsOfFile: pathToMark!.path)
            
        }
        self.producerImage = self.imageOfProducer.image
        
        aProducer?.nameProducer = self.name!
        if (self.producerImage == nil)
        {
            aProducer?.logoProducer = nil
            
        }
        else
        {
            aProducer?.logoProducer = self.producerImage.pngData()
            
        }
        
        
        if(allCorrect){

            if self.aAction == "addProducer"
            {
                
                aProducer = Producer(nameProducer: self.name!, logoProducer: self.producerImage)
                aModel!.producersNamed[aProducer!.nameProducer] = aProducer
                aModel!.producers.removeAll()
                aModel!.producers = aModel!.producersNamed.map { (name, producer) in
                    return producer
                }
                performSegue(withIdentifier: "unwindSegueFromProducerView", sender: self)
            }else{

            
            print("UNWIND")
            print(allCorrect)
                print(aProducer?.logoProducer)
            performSegue(withIdentifier: "unwindSegueFromProducerView", sender: self)//posible error

                }
        }
        
        
    }

    
 
    
    @objc func tapGestureAction(gesture: UITapGestureRecognizer){
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
        notifyUser(self, alertTitle: "The camera is unavailable", alertMessage: "The camera cant be run in the simulator", runOnOK: {_ in})
            return
        }
        imgPicker.allowsEditing = false
        imgPicker.sourceType = UIImagePickerController.SourceType.camera
        imgPicker.cameraCaptureMode = .photo
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
        
        
    }
}
extension ProducerViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newPic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        aProducer?.logoProducer = newPic.pngData()
        self.imageOfProducer.image = newPic
        self.imageOfProducer.setNeedsDisplay()
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkType(_ introduced: String, _ expected: String) -> Bool {
        
        if introduced.isEmpty {
            
            
                notifyUser(self, alertTitle: "Field is emty", alertMessage: "Sorry cant leave the field empty", runOnOK: {_ in})
                    return false
                
        }
        if expected == "word"{
            let phone = introduced.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if !phone.isEmpty  {
                notifyUser(self, alertTitle: "Type of Input Incorrect", alertMessage: "\(introduced): Wasn't cant take numbers. Please correct it to save", runOnOK: {_ in})
                    return false
                }
                return true
            
           
            
        }else{
            return true
        }
    }
}
