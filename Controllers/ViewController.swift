//
//  ViewController.swift
//  BeerApp
//
//  Created by Jorge Pérez Ramos on 26/12/20.
//

import UIKit


class ViewController: UITableViewController {

    @IBOutlet weak var addProdButt: UIButton!
    @IBOutlet weak var discoverBtt: UIButton!
    @IBOutlet weak var addBeerButt: UIButton!
    @IBOutlet weak var delBeerButt: UIButton!
    
    var model = Model()
    var editingStyle:UITableViewCell.EditingStyle?

    override func viewDidLoad() {
        super.viewDidLoad()
        model.producers = model.producersNamed.map { (name, producer) in
            return producer
        }
        
        model.producers.sort{$0.nameProducer < $1.nameProducer}
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appEnterBackGround(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        self.editingStyle = UITableViewCell.EditingStyle.none
        tableView.reloadData()
 
    }//end view did load
    
    //If the app closes or goes to background
    @objc func appEnterBackGround(notification: NSNotification){
        
            //update map
            model.producers.forEach{ model.producersNamed.updateValue($0, forKey: $0.nameProducer)}
            
        
           if !model.writeProducersInfosToDocuments(model.NAME_OF_PRODUCERS_FILE_IN_DOCUMENTS, folder: model.NAME_OF_FOLDER_IN_DOCUMENTS){
               notifyUser(self, alertTitle: "IO Error", alertMessage: "Error When Writting Producers", runOnOK: {_ in})
               
           }else{
               print("Prod Saved Correctly")
               
           }
            
       }
    //Activation when we come back from any segue(unwind)
    @IBAction func returnfromDetail(segue:UIStoryboardSegue)->Void{
        model.producers.forEach{ b in b.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})}
        model.producers = cleanBeers(model.producers, self)
        model.producers = cleanProducers(model.producers,self)
        model.producers.sort{$0.nameProducer < $1.nameProducer}

        tableView.reloadData()
       }
    
       //Behaviour for add beer Button
    @IBAction func addBeerAct(_ sender: Any){
            //Depending of current state of button
           if self.editingStyle == UITableViewCell.EditingStyle.none{
                   self.editingStyle = .insert
                   addBeerButt.setTitle("Done", for: .normal)
                   delBeerButt.isEnabled = false
                    discoverBtt.isEnabled = false
                    addProdButt.isEnabled = false
                   tableView.setEditing(true, animated: true)
                   
           }else if self.editingStyle == .insert{
                   
                   self.editingStyle = UITableViewCell.EditingStyle.none

                   delBeerButt.isEnabled = true
                discoverBtt.isEnabled = true
                addProdButt.isEnabled = true
                   addBeerButt.setTitle("Add Beer", for: .normal)
                   tableView.setEditing(false, animated: true)
                   
               }
           
    }
    
    //Behaviour for add producer Button
    @IBAction func addProdAct(_ sender: Any) {
        performSegue(withIdentifier: "segueToProducer", sender: "addProducer")
        
    }
    
    //Behaviour for dicover Beers Button
    @IBAction func discoverAct(_ sender: Any) {
        performSegue(withIdentifier: "segueToDiscover", sender: "discoverBeer")
        
    }
    
    //Behaviour for delete beer Button
    @IBAction func delBeerAct(_ sender: Any){

            //Depending of current state of button
           if self.editingStyle == UITableViewCell.EditingStyle.none{
               
                   self.editingStyle = .delete
                   delBeerButt.setTitle("Done", for: .normal)
                   addBeerButt.isEnabled = false
            discoverBtt.isEnabled = false
            addProdButt.isEnabled = false
                   tableView.setEditing(true, animated: true)
                   
           }else if self.editingStyle == .delete{
                   
                   self.editingStyle = UITableViewCell.EditingStyle.none
                   addBeerButt.isEnabled = true
                discoverBtt.isEnabled = true
                addProdButt.isEnabled = true
                   delBeerButt.setTitle("Remove Beer", for: .normal)
                   tableView.setEditing(false, animated: true)
                   
               }
           
    }
    
    //Return editing style of table
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return self.editingStyle!
    }
    //Returns header if info source not found
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Table Header"
    }
    
    //Adds or deletes beers from a given producer
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        let section = indexPath.section
        let row = indexPath.row
        let producer = model.producers[section]
        
        switch self.editingStyle! {
        case .none:
            break
        case .insert:
            let b = Beer()
            b.producerBeer = producer.nameProducer
            
            producer.beersCollect?.insert(b, at: row + 1)
            producer.beersCollect?.sort(by: {($0.nameBeer) < ($1.nameBeer)})
            
            tableView.insertRows(at: [indexPath], with: .fade)
            tableView.reloadSections(IndexSet(integer: section), with: .fade)
            tableView.reloadData()
        case .delete:
            producer.beersCollect?.remove(at: row)
            tableView.deleteRows(at: [indexPath], with:.fade)
            tableView.reloadData()
        @unknown default:
            break
        }
        
    }
    
    //Returns number of producers for header count
    override func numberOfSections(in tableView: UITableView) -> Int{
       return model.producers.count
      
    }
    
    //Reutns number of beers for cell count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let producerNumber = section
        let producer = model.producers[producerNumber]
        return producer.beersCollect?.count ?? 0
      
    }
    
    //Fetches and creates new custom cell
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let producerNum = indexPath.section

        let producer = model.producers[producerNum]
        let b = producer.beersCollect?[indexPath.row]
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.mainLabel.text = b?.nameBeer
        if let pic = b?.pictureBeer{
            cell.mainPhoto.image = UIImage(data: pic)
                
            }
            if let name = b?.nameBeer{
                cell.mainLabel.text = name
                
            }
        return cell
    }
    
    //Returns height for headers
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    //Fetches and creates new custom header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let producer = model.producers[section]

        let headerView = Bundle.main.loadNibNamed("TableViewHeader", owner: self, options: nil)?.first as! TableViewHeader
        headerView.ProducerLabel.text = producer.nameProducer
        headerView.tag = section
    
        let tapRec = UITapGestureRecognizer(target: self,action: #selector(ViewController.jumpToProducerView(_:)))
        tapRec.numberOfTapsRequired = 1

            headerView.addGestureRecognizer(tapRec)
        
        return headerView
    }
    
    //Handles segue to producer
    @objc func jumpToProducerView(_ sender:UIGestureRecognizer){
        
        if sender.state == .ended{
            guard
                let n = sender.view?.tag
                else {
                return
            }
            performSegue(withIdentifier: "segueToProducer", sender: model.producers[n])
        }
        
    }
    
    //Returns height for cell
    func tableView(_ tableView: UITableView, heightForRowAt indexpath: Int) -> CGFloat {
            return 100
    }
    
    //Handles segue to beer detail
    func tableView(_ tableView: UITableView, _ indexPath: IndexPath){
       
           let producer = model.producers[indexPath.section]
           let beer =  producer.beersCollect?[indexPath.row]
           performSegue(withIdentifier: "segueToBeer", sender: beer)
           
    }
    
    var selectedBeer: Beer?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let producer = model.producers[indexPath.section]
        _ = indexPath.section
        let beerLine =  producer.beersCollect?[indexPath.row]
        selectedBeer = beerLine
        performSegue(withIdentifier: "segueToBeer", sender: nil)
        
    }
    
    //Handles in what terms the segue to producer is being done
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch segue.identifier! {
        case "segueToProducer":
            _ = segue.destination as! ProducerViewController
            
            if sender as? String == "addProducer"
            {
                let destController = segue.destination as! ProducerViewController
                destController.aModel = model
                destController.aAction = (sender as? String)!
            }
            else
            {
                let destController = segue.destination as! ProducerViewController
                destController.aModel = model
                destController.aProducer = sender as? Producer
                
            }
            
        case "segueToBeer":
            let destController = segue.destination as! BeerViewController
            destController.aModel = model
            destController.aBeer = selectedBeer
        case "segueToDiscover":
            _ = segue.destination as! DiscoverViewController
        default:
            break
        }
    }
    
    //heightForRow
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 44.0
       }
    //heightForFooter
    override func tableView(_ tableView: UITableView,  heightForFooterInSection section: Int) -> CGFloat {
           return CGFloat.leastNormalMagnitude
       }
}//end ViewController




//declaration of fuction clean --> mantains the beer table
func cleanBeers(_ producers:[Producer], _ viewController:UIViewController) -> [Producer]
    {

    _ = Set<String>()
    _ = [String: Producer]()
     var allBears:[Beer] = []
    
     producers.forEach {(value) in
        if value.beersCollect != nil{
            allBears+=value.beersCollect!
            
        }

     }
      allBears = allBears.sorted(by: { $0.nameBeer < $1.nameBeer})
     
     for (index, bear) in allBears.enumerated() {
         if !(index==allBears.count-1){
             
             
             var nameBeerCurrent = String(bear.nameBeer)

            let nameBeerNext = allBears[index+1].nameBeer
             nameBeerCurrent = allBears[index].nameBeer
             if (nameBeerNext.elementsEqual(nameBeerCurrent))
             {
                 if (allBears[index].capBeer == allBears[index+1].capBeer && allBears[index].expDateBeer == allBears[index+1].expDateBeer && allBears[index].nationalityBeer == allBears[index+1].nationalityBeer && allBears[index].rateBeer == allBears[index+1].rateBeer){
                    _ = allBears[index].producerBeer
                    _ = allBears[index].nameBeer
                    _ = false
                    var countDuplu = 0
                    
                    let producersDupli:[Producer] = producers.filter{$0.nameProducer == allBears[index].producerBeer}
                    let indexsProducerDupli = producers.enumerated().filter({$0.element.nameProducer == allBears[index].producerBeer}).map({$0.offset})
                    
                    
                    for (var indexProducer, producer) in producersDupli.enumerated() {
                        if producer.beersCollect != nil
                        {
                            indexProducer = indexsProducerDupli[indexProducer]

                        let bears:[Beer] = producer.beersCollect!.filter{$0.nameBeer == allBears[index].nameBeer}

                        countDuplu += bears.count
                        if (countDuplu == 2)
                        {
                            
                            let indexsBeer = producer.beersCollect?.enumerated().filter({$0.element.nameBeer == allBears[index].nameBeer}).map({$0.offset})
                            
                            var tempInteger = Int((producers[indexProducer].beersCollect?[indexsBeer![0]].duplicate)!)
                            tempInteger! += 1
                            producers[indexProducer].beersCollect?[indexsBeer![0]].duplicate  = String(tempInteger!)
                        
                            producers[indexProducer].beersCollect![indexsBeer![0]].nameBeer = producers[indexProducer].beersCollect![indexsBeer![0]].nameBeer + "_" + producers[indexProducer].beersCollect![(indexsBeer?[0])!].duplicate
                            
                            
                            if (allBears.enumerated().filter({$0.element.nameBeer == producers[indexProducer].beersCollect![indexsBeer![0]].nameBeer }).map({$0.offset}).count == 2)
                            {
                                var tempInteger = Int ((producers[indexProducer].beersCollect?[indexsBeer![0]].duplicate)! )
                                tempInteger! += 1
                                producers[indexProducer].beersCollect?[indexsBeer![0]].duplicate = String(tempInteger!)
                            
                                producers[indexProducer].beersCollect![indexsBeer![0]].nameBeer = allBears[index].nameBeer + "_" + producers[indexProducer].beersCollect![(indexsBeer?[0])!].duplicate
                                
                            }
                            
                            if (producers[indexProducer].beersCollect?[indexsBeer![0]].duplicate == "3")
                                {
            
                                    producers[indexProducer].beersCollect?.remove(at: indexsBeer![0])
                                viewController.dismiss(animated: false, completion: nil)
                                notifyUser(viewController, alertTitle: "Redundancy Alert", alertMessage: "Cant have more than three copies of the same beer", runOnOK: {_ in})
                                
                                
                                
                            }
                        }
                            

                        producers[indexProducer].beersCollect = producers[indexProducer].beersCollect!.sorted(by: { $0.nameBeer < $1.nameBeer})
                        break
                        
                    }
                    }
                    
                 }

            }
        }

            
        
     }
    let producersSort = producers.sorted(by: { $0.nameProducer < $1.nameProducer})
    return producersSort
}


//declaration of fuction clean --> mantains the beer table
func cleanProducers(_ producers:[Producer], _ viewController:UIViewController) -> [Producer]
    {

    var producers = producers.sorted(by: { $0.nameProducer < $1.nameProducer})

     
     for (index, producer) in producers.enumerated() {
         if !(index==producers.count-1){
            let producersDuplic = producers.filter{$0.nameProducer == producer.nameProducer}
            
            if (producersDuplic.count > 0)
            {
   
                if (producersDuplic.count == 2)
                {
                    var tempInteger = Int(producers[index].duplicate)
                    tempInteger! += 1
                    producers[index].duplicate = String(tempInteger!)
                    producers[index].nameProducer = producer.nameProducer + "_" + producer.duplicate
                    
                }
                if producers.filter({$0.nameProducer == producers[index].nameProducer}).count == 2
                {
                var tempInteger = Int(producers[index].duplicate)
                tempInteger! += 1
                producers[index].duplicate = String(tempInteger!)
                producers[index].nameProducer = producer.nameProducer + "_" + producer.duplicate
                    
                }
                if (producers[index].duplicate == "3")
                    {

                        producers.remove(at: index)
                    viewController.dismiss(animated: false, completion: nil)
                    notifyUser(viewController, alertTitle: "Redundancy Alert", alertMessage: "Cant have more than three copies of the same producer", runOnOK: {_ in})

                }
            }
         }
        
        
     }
        producers = producers.sorted(by: { $0.nameProducer < $1.nameProducer})
        
        return producers
    }
