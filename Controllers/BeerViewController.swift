//
//  BeerViewController.swift
//  BeerApp
//
//  Created by Grégoire LARATTE on 27/12/20.
//


import UIKit

class BeerViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate{
    
    let yearMoths = ["January","February","March","April","May","June","July","Agust","September","October","November","December"]
    
    let monthDays = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    @IBOutlet weak var producerSelector: UIPickerView!
    
    @IBOutlet weak var nameText: UITextField!
    
    
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    @IBOutlet weak var nationalityText: UITextField!
    @IBOutlet weak var capText: UITextField!
    //@IBOutlet weak var expDText: UITextField!
    @IBOutlet weak var rateText: UITextField!

    @IBOutlet weak var idText: UILabel!
    @IBOutlet weak var ibuText: UITextField!
    
    //volDText
    
   
    @IBOutlet weak var volDText: UITextField!
    
    @IBOutlet weak var beerImageFrame: UIImageView!
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
        
    }
    
    var aModel: Model?
    var aBeer : Beer?
    
    var name: String?
    var type: String?
    var producer: String?
    var nationality: String?
    var cap: String?
    var expD: String?
    var rate: String?
    var id: String?
    var ibu: String?
    var volD: String?

    var beerImage: UIImage!
    
    var tempM:String?
    var tempD:String?
    var listMakersNames:[String]?
    let imgPicker = UIImagePickerController()
    

   
    @IBOutlet weak var expDatePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expDatePicker.dataSource = self
        expDatePicker.delegate = self
        producerSelector.dataSource = self
        producerSelector.delegate = self
        listMakersNames = aModel?.producers.map{$0.nameProducer}
        self.name = aBeer?.nameBeer
        self.type = aBeer?.typeBeer
        self.producer = aBeer?.producerBeer
        self.nationality = aBeer?.nationalityBeer
        self.cap = aBeer?.capBeer
        self.expD = aBeer?.expDateBeer
        self.rate = aBeer?.rateBeer
        self.id = aBeer?.IDBeer
        self.ibu = aBeer?.IBUBeer
        self.volD = aBeer?.volBeer
        let tempDiv = aBeer?.expDateBeer.components(separatedBy: " ")
        self.tempD = tempDiv![1]
        self.tempM = tempDiv![0]
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let nameOfPicture = "\(self.id!).png"
        let path = documentDirectory[0].appendingPathComponent(nameOfPicture)
        
        if (FileManager.default.fileExists(atPath: path.path)) {
            self.beerImage = UIImage(contentsOfFile: path.path)
        }else{
            self.beerImage = UIImage(data:(aBeer?.pictureBeer)!)
            
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.beerImageFrame.addGestureRecognizer(tapGesture)
        
 
    }
    override func viewWillAppear(_ animated: Bool) {
        nameText.text = self.name
        switch self.type
        {
            case "cane":
                typeSegment.selectedSegmentIndex = 0
            case "bottle":
                typeSegment.selectedSegmentIndex = 1
            default:
                typeSegment.selectedSegmentIndex = 0
        }
        
        
        
        let producerNumber = (listMakersNames?.firstIndex(of: self.producer!))!
        producerSelector.selectRow(producerNumber, inComponent: 0, animated: true)
        let divided = self.expD?.components(separatedBy: " ")
        let month = divided![0]
        let day = divided![1]
        print("*/*/*/*/*/*/*/*/*/*//*/*/*/*/")
        print(month)
        var m = 0
        
        //["January","February","March","April","May","June","July","Agust","September","October","November","December"]
        switch month {
        //Spanish
        case "Enero":
            m = 0
        case "Febrero":
            m = 1
        case "Marzo":
            m = 2
        case "Abril":
            m = 3
        case "Mayo":
            m = 4
        case "Junio":
            m = 5
        case "Julio":
            m = 6
        case "Agosto":
            m = 7
        case "Septiembre":
            m = 8
        case "Octubre":
            m = 9
        case "Noviembre":
            m = 10
        case "Diciembre":
            m = 11
          //English
        case "January":
            m = 0
        case "February":
            m = 1
        case "March":
            m = 2
        case "April":
            m = 3
        case "May":
            m = 4
        case "June":
            m = 5
        case "July":
            m = 6
        case "Agust":
            m = 7
        case "September":
            m = 8
        case "October":
            m = 9
        case "November":
            m = 10
        case "December":
            m = 11
            
        default:
            m = 11
        }
        print(day)
        expDatePicker.selectRow(m, inComponent: 0, animated: true)
        expDatePicker.selectRow((Int(day)!)-1, inComponent: 1, animated: true)
        
        nationalityText.text = self.nationality
        capText.text = self.cap
       // expDText.text = self.expD
        rateText.text = self.rate
        idText.text = self.id
        ibuText.text = self.ibu
        volDText.text = self.volD
        beerImageFrame.image = self.beerImage
    }
    
    @IBAction func acceptAcceptAndReturn(_ sender: Any){
        var allCorrect : Bool = true
 
        self.name = self.nameText.text
        if !checkType(self.nameText.text!, "word")  {
            self.nameText.textColor = .red
            allCorrect = false
        }
        
        self.nationality = self.nationalityText.text
        if !checkType(self.nationalityText.text!, "word")  {
            self.nationalityText.textColor = .red
            allCorrect = false
        }
        self.cap = self.capText.text
     //   self.expD = self.expDText.text

        self.rate = self.rateText.text
        if !checkType(self.rateText.text!, "word")  {
            self.rateText.textColor = .red
            allCorrect = false
        }
        self.id = self.idText.text
        self.ibu = self.ibuText.text
        self.volD = self.volDText.text
        switch self.typeSegment.selectedSegmentIndex {
        case 0:
            self.type = "can"
        case 1:
            self.type = "bottle"
        default:
            break;
        }
        self.producer = aModel?.producers[producerSelector.selectedRow(inComponent: 0)].nameProducer

        print("**********------**************-")
        print(producer)
        
        let month = yearMoths[expDatePicker.selectedRow(inComponent: 0)]
            
        let day = monthDays[expDatePicker.selectedRow(inComponent: 1)]
            
        self.expD = "\(month) \(day)"
        print("12122112121212121212121")
        print(self.expD)
        aBeer?.expDateBeer = self.expD!
        
       
        aBeer?.typeBeer = self.type!
        
        aBeer?.nationalityBeer = self.nationality!
        aBeer?.capBeer = self.cap!
        
        aBeer?.rateBeer = self.rate!
        aBeer?.IDBeer = self.id!
        aBeer?.IBUBeer = self.ibu!
        aBeer?.volBeer = self.volD!
        aBeer?.pictureBeer = self.beerImage.pngData()
        
        if self.producer != aBeer?.producerBeer{
            
            let ogProducer = aModel?.producersNamed[(aBeer?.producerBeer)!]
            let indexBeerList = ogProducer?.beersCollect?.firstIndex(of: aBeer!)
            ogProducer?.beersCollect?.remove(at: indexBeerList!)
            
            aBeer?.producerBeer = self.producer!
 
            aModel?.producersNamed[self.producer!]?.beersCollect?.append(aBeer!)
            
            

  
           
            aModel!.producers.removeAll()
            aModel!.producers = aModel!.producersNamed.map { (name, producer) in
                return producer
            }
            
        }
        if (self.name != aBeer?.nameBeer) || (self.expD != aBeer?.expDateBeer) {
            aBeer?.nameBeer = self.name!
            aBeer?.expDateBeer = self.expD!
            var noBlancName = aBeer?.nameBeer.replacingOccurrences(of: "\\s*",
                                                    with: "$1",
                                                    options: [.regularExpression])
            
            let noBlancDate = aBeer?.expDateBeer.replacingOccurrences(of: "\\s*",
                                                          with: "$1",
                                                          options: [.regularExpression])
            var nameOfImage = "\(noBlancName!)\(noBlancDate!)"
            let oldId = aBeer?.IDBeer
            aBeer?.IDBeer = nameOfImage
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let currentId = aBeer?.IDBeer
            let nameOfPicture = "\(currentId!).png"
            let oldNameOfPicture = "\(oldId!).png"
            let path = documentDirectory[0].appendingPathComponent(nameOfPicture)
            let oldPath = documentDirectory[0].appendingPathComponent(oldNameOfPicture)
            do{
            try FileManager.default.moveItem(at: oldPath, to: path)
                print("Rename success to: \(path.path)")
                
            }catch {
                print("ERROR in Rename  to: \(path.path) from \(oldPath.path)")
                
            }
        }else  {
            print("It wasnt necesary to reCalc the iD")
        }

        if(allCorrect){
            
            performSegue(withIdentifier: "unwindSegueFromBeerView", sender: self)
            
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

extension BeerViewController : UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == producerSelector {
        guard
            let numberRows = aModel?.producers.count
            else {
            return 0
        }
        return numberRows
        }else if pickerView == expDatePicker{
            
            if component == 0{
                return yearMoths.count
                
            }else if component == 1{
                return monthDays.count
                
            }
        }
        return 0
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == producerSelector {
        return 1
        }else if pickerView == expDatePicker{
            return 2
        }
        return 1
    }
   
  
  
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        
        if picker == producerSelector {
            return listMakersNames?[row] ?? "Unknown Producer"
        }else if picker == expDatePicker{
            if component == 0{
                return yearMoths[row]
                
            }else if component == 1{
                return monthDays[row]
                
            }
        }
        
        
        return "Unknown"
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
       
        
        
        
        if pickerView == producerSelector {
            self.listMakersNames?[row] ?? "Unknown Producer"
        }else if pickerView == expDatePicker{
            if component == 0{
                self.tempM = yearMoths[row]
                
            }else if component == 1{
                self.tempD =  monthDays[row]
                
            }
            self.expD = "\(tempM!) \(tempD!)"
        }
   }
    
    
    func checkType(_ introduced: String, _ expected: String) -> Bool {
        
        if introduced.isEmpty {
            
            
                notifyUser(self, alertTitle: "Field is emty", alertMessage: "Sorry cant leave the field empty", runOnOK: {_ in})
                    return false
                
        }
        if expected == "word"{
            let phone = introduced.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if !phone.isEmpty  {
                notifyUser(self, alertTitle: "Type of Input Incorrect", alertMessage: "\(introduced): Can't take numbers. Please correct it to save", runOnOK: {_ in})
                    return false
                }
                return true
            
           
            
        }else{
            return true
        }
    }
}




extension BeerViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newPic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.beerImage = newPic
        self.beerImageFrame.image = newPic
        self.beerImageFrame.setNeedsDisplay()
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}




