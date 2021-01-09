//
//  discoverViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 8/1/21.
//

import Foundation
import UIKit
import SwiftyJSON

class DiscoverViewController: UIViewController {
    //name
    //beerDescription
    //beerImage

 
    @IBOutlet weak var imageBeer: UIImageView!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
       
        print("DISCOVER CLASS")
        aRandomBeer()
    
          }//end view didLoad
    
    @IBAction func getMeAnotehr(_ sender: Any){
     aRandomBeer()
    }
    
    
    
    @IBAction func acceptAcceptAndReturn(_ sender: Any){
        var allCorrect : Bool = true
        print("CLIKED ACCEPT AND RETURN")
       
/*
        if !checkType(self.nameOfProducer.text!, "word")  {
            
            self.nameOfProducer.textColor = .red
            allCorrect = false
        }
        self.name = self.nameOfProducer.text
        self.number = self.numberOfBeers.text
        self.producerImage = self.imageOfProducer.image
        
        aProducer?.nameProducer = self.name!
        aProducer?.logoProducer = self.producerImage
        
        if(allCorrect){
            print(self.aAction)
            if self.aAction == "addProducer"
            {
                print("ADD PRODUCER !!!!!")
                aProducer = Producer(nameProducer: self.name!, logoProducer: self.producerImage)
                aModel!.producersNamed[aProducer!.nameProducer] = aProducer
                aModel!.producers.removeAll()
                print("azeerrttttttttttttttt")
                print(aModel?.producersNamed.forEach{
                    print($0.value.nameProducer)
                })
                aModel!.producers = aModel!.producersNamed.map { (name, producer) in
                    return producer
                }
                performSegue(withIdentifier: "unwindSegueFromProducerView", sender: self)//posible error
            }else{
            */
            print("UNWIND")
           
            
            performSegue(withIdentifier: "unwindSegueFromDiscoverView", sender: self)//posible error
               // }
     //   }
        
        
    }
    
    
    func aRandomBeer(){
       print("Fetching Beer..")
        
        
        let randomNumber = Int.random(in: 1...200)
        var contents = "blanck"
        if let url = URL(string: "https://api.punkapi.com/v2/beers/\(randomNumber)") {
            do {
                contents = try String(contentsOf: url)
               // print(contents)
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    
        
        
        print(contents )
        let data = Data(contents.utf8)
        
        let json = try! JSON(data: data)
    
        
        let id = json[0]["name"] ?? "Unkown"
        let desc = json[0]["description"] ?? "Unkown"
        let img = json[0]["image_url"] ?? "Unkown"
        var urlStrings = "\(img)"
        var finalImage : UIImage
        
        print("------------------")
        print(urlStrings)
        let catPictureURL = URL(string: urlStrings)!
        
        let session = URLSession(configuration: .default)
        var image : UIImage?
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { [self] (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                         image = UIImage(data: imageData)
                        
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        
        print("ID: \(id)")
        name.text = "\(id)"
        beerDescription.text = "\(desc)"
        while image == nil{
            print("Downloading image...")
            sleep(1)
            imageBeer.image = image
        }
        
        
        
        
    }


}//end class
    

