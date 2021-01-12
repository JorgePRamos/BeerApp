//
//  discoverViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 7/1/21.
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
        aRandomBeer()
    }//end view didLoad
    
    //Behaviour for button reload
    @IBAction func getMeAnother(_ sender: Any){
     aRandomBeer()
    }

    @IBAction func acceptAcceptAndReturn(_ sender: Any){
        var allCorrect : Bool = true

            performSegue(withIdentifier: "unwindSegueFromDiscoverView", sender: self)//posible error
        
    }
    
    
    func aRandomBeer(){
       print("Fetching Beer..")
        
        
        let randomNumber = Int.random(in: 1...200)
        var contents = "blanck"
        if let url = URL(string: "https://api.punkapi.com/v2/beers/\(randomNumber)") {
            do {
                contents = try String(contentsOf: url)

            } catch {
                print("Could not fetch contents")
            }
        } else {
            print("Bad URL")
        }
    

        let data = Data(contents.utf8)
        
        let json = try! JSON(data: data)
    
        
        let id = json[0]["name"]
        let desc = json[0]["description"]
        let img = json[0]["image_url"]
        let urlStrings = "\(img)"
        let finalImage : UIImage
        
        print("------------------")
        print(urlStrings)
        let catPictureURL = URL(string: urlStrings)!
        
        let session = URLSession(configuration: .default)
        var image : UIImage?
        // Define a download task
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
    
