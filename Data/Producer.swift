//
//  Producer.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 27/12/20.
//

import Foundation
import UIKit

public class Producer : NSObject, NSCoding, NSSecureCoding, Codable{

    public static var supportsSecureCoding: Bool = true
    
    
    var nameProducer : String
    var duplicate : String
    var logoProducer : Data?
    var beersCollect : [Beer]?
    
    public enum Keys: String,CodingKey {
        case nameProducer
        case duplicate
        case logoProducer
        case beersCollect
    }
    
    init(nameProducer:String, logoProducer:UIImage? = nil) {
        self.nameProducer = nameProducer
        self.logoProducer = logoProducer?.pngData()
        self.duplicate = "1"
        self.beersCollect = [Beer]()
    }
    
    public override init() {
        self.nameProducer="none"
        self.duplicate = "1"
        self.logoProducer = nil
        self.beersCollect = [Beer]()
    }

    

    init?(record:String, delimiter del:String) {
        print("CREANDO PRODUCER")
        let tokens = record.components(separatedBy: del)//separar linia por delimitador
        let dfm = FileManager.default
        self.beersCollect = [Beer]()
        print("#tokens  --> \(tokens) ")
        let  tempNameProducer = tokens[2]//get name producer
        guard
            tokens.count == 11,//11¿
            
            !tempNameProducer.isEmpty
        else {
            print("#Problem with tokens --> \(tokens.count)")
            print("#Problem with  --> \(tokens[0])")
            return nil }

    
        //creation of a nam e of picture lowercased with no space
        let namePicProducerSpaced = tokens[2]
        let trimed = namePicProducerSpaced.replacingOccurrences(of: "\\s*",
                                                with: "$1",
                                                options: [.regularExpression])
        print("#EMPEZAMOS CON IMAGEN")
        var tempMarkImage : UIImage?
        if

            //let bits = splitIntoNameAndExtension(total: tempMark),//maxus
        
            //goes for pic
            let pathToMark = Bundle.main.url(forResource: trimed.lowercased(),withExtension: "png", subdirectory: "beerApp-fotos"),
            dfm.fileExists(atPath: pathToMark.path)
             
        {   tempMarkImage = UIImage(contentsOfFile: pathToMark.path)
            print("Assigned specific photo")}else    {
            print("#Problem with picture --> \(trimed.lowercased())")
           
            if
                let pathToMark = Bundle.main.url(forResource:"defaultPic",withExtension: "png"),
                dfm.fileExists(atPath: pathToMark.path)
                
            {tempMarkImage = UIImage(contentsOfFile: pathToMark.path)
                print("Getting default pic")
            }else{
                print("                                             #PROBLEMA  ")
                return nil}
            //return nil }

        }
        print("#ACABAMOS CON IMAGEN")
        self.nameProducer = tempNameProducer
        self.logoProducer = tempMarkImage?.pngData()
        self.duplicate = "1"
        print("#nameProducer  --> \(self.nameProducer) ")

    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.beersCollect = try container.decodeIfPresent([Beer].self, forKey: .beersCollect)
        self.duplicate = try container.decodeIfPresent(String.self, forKey: .duplicate)!
        self.logoProducer = try container.decodeIfPresent(Data.self, forKey: .logoProducer)
        self.nameProducer = try container.decodeIfPresent(String.self, forKey: .nameProducer)!
    }
    
    
    /*
     init?(record:String, delimiter del:String) {

         let tokens = record.components(separatedBy: del)//separar linia por delimitador
         let dfm = FileManager.default

         guard
             tokens.count == 2,
             let  tempNameProducer = tokens.first,//name producer primer elemento
             !tempNameProducer.isEmpty
         else { return nil }

         let tempMark = tokens[1]//¿?¿?

         guard

             let bits = splitIntoNameAndExtension(total: tempMark),//maxus
             
             let pathToMark = Bundle.main.url(forResource: bits[0],withExtension: bits[1], subdirectory: "beerApp-fotos"),
             dfm.fileExists(atPath: pathToMark.path),
             let tempMarkImage = UIImage(contentsOfFile: pathToMark.path)
         else    { return nil }

         

         self.nameProducer = tempNameProducer
         self.logoProducer = tempMarkImage
     

     }
     */
    
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(nameProducer, forKey: "nameProducer")
        coder.encode(logoProducer, forKey: "logoProducer")
        coder.encode(beersCollect, forKey: "beersCollect")
        coder.encode(duplicate, forKey: "duplicate")
    }
    
    public required init?(coder decoder: NSCoder) {
        self.nameProducer = decoder.decodeObject(forKey: "nameProducer") as! String
        self.logoProducer = decoder.decodeObject(forKey: "logoProducer") as! Data?
        self.beersCollect = decoder.decodeObject(forKey: "beersCollect") as! [Beer]?
        self.duplicate = decoder.decodeObject(forKey: "duplicate") as! String
    }
    
    
}
