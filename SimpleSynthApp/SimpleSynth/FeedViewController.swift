//
//  FeedViewController.swift
//  SimpleSynth
//
//  Created by Estee Rebibo on 11/20/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import UIKit
import Firebase


class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate
{
   
    var settingVC: SettingViewController = SettingViewController()

    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    var synths = [ModuleBoard]();
    var index = -1
    let ref = FIRDatabase.database().reference()
    
    
   
   // var exampleSynth = Synth()
 
    
    override func viewDidLoad() {
      //  var lastSynth = exampleSynth
        searchBar.hidden = true
        var vcs = self.tabBarController?.viewControllers
        //print("LOOK AT ME " + vcs![1] is SettingViewController)
        settingVC = vcs![1] as! SettingViewController
        
        activityInd.hidesWhenStopped = true
        self.feedCollectionView.dataSource = self
        self.feedCollectionView.delegate = self
        
         let synthesizers = ref.childByAppendingPath("Synthesizer")
        synthesizers.queryOrderedByChild("MB").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let MB = snapshot.value!["MB"] as? String{
                let mb = self.dictionaryFromJson(MB)
                
                var newMB = ModuleBoard(dictionary: mb)
               
                /**
                newMB.currentFrequency = (mb["currentFrequency"] as? Float)!
                newMB.inputFrequency = (mb["inputFrequency"] as? Float)!
                newMB.keyCurrentlyHeld = (mb["keyCurrentlyHeld"] as? Bool)!
                newMB.keyWasHeld = (mb["keyWasHeld"] as? Bool)!
                newMB.indexOfLastKeyPress = mb["indexOfLastKeyPress"] as! Int
                mb.key
                print("mb")
                print(newMB)
              **/
                self.synths.append(newMB)
                dispatch_async(dispatch_get_main_queue()) {
                    self.feedCollectionView.reloadData()
                    
                }

                //print(self.synths.count)
 
            }
 
            if let user = snapshot.value!["user"] as? String {
                print("\(snapshot.key) has user: \(user)")
            }
            
           
        })
        
        /**
        let waves = [BasicWaves.Sine, BasicWaves.Square, BasicWaves.Triangle]
        var k = 0
        for (var i = 0; i<10; i++){
            var newMB = ModuleBoard()
             var osc = Oscillator()
            osc.isTiedToKBInput = true
            osc.waveForm = waves[k] //change so varies based on input
            newMB.theBoard.append(osc)
            synths.append(newMB);
            k = k+1
            if (k == 3){
                k = 0;
            }
        }
 **/
        self.searchBar.delegate = self
        
        let doubleTaps = UITapGestureRecognizer(target: self, action: "doubleTapTriggered:")
        doubleTaps.numberOfTapsRequired = 2
        doubleTaps.numberOfTouchesRequired = 1
        let singleTaps = UITapGestureRecognizer(target: self, action: "singleTapTriggered:")
        singleTaps.numberOfTapsRequired = 1
        singleTaps.numberOfTouchesRequired = 1
        singleTaps.requireGestureRecognizerToFail(doubleTaps);
        self.view.addGestureRecognizer(singleTaps)
        self.view.addGestureRecognizer(doubleTaps)
        
    }
    func dictionaryFromJson(json: String?) -> NSDictionary {
        var result = NSDictionary()
        if json == nil {
            return result
        }
        if let jsonData = json!.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                if let jsonDic = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    result = jsonDic
                }
            } catch {
                print("ERROR: Invalid json!")
            }
        }
        return result
    }

    
    func doubleTapTriggered(sender : UITapGestureRecognizer)
    {
        
        let tapLocation = sender.locationInView(self.feedCollectionView)
        print(tapLocation);
        if (self.feedCollectionView.indexPathForItemAtPoint(tapLocation) != nil){
        let indexPath : NSIndexPath = self.feedCollectionView.indexPathForItemAtPoint(tapLocation)!
               //name = synths[indexPath]
       // self.performSegueWithIdentifier("segue", sender: nil)
       
        }
    }
    func singleTapTriggered(sender : UITapGestureRecognizer){
        
        let tapLocation = sender.locationInView(self.feedCollectionView)
       
        if (self.feedCollectionView.indexPathForItemAtPoint(tapLocation) != nil){
        
            let indexPath : NSIndexPath = self.feedCollectionView.indexPathForItemAtPoint(tapLocation)!
            /**
            if (index == indexPath.row){
                 exampleSynth.pausePlayer()
            }
            else{
 **/
           // print("clicked")
                index = indexPath.row
            let mod = synths[index]
          //  print(mod)
           //     print(mod)
            exampleSynth.updateModuleBoard(mod)
            settingVC.mb = mod
            
            let newOsc = mod.theBoard[0] as! Oscillator
            settingVC.baseOsc = newOsc
            if ( newOsc.frequencyController != nil){
                let newFO = newOsc.frequencyController as! Oscillator
                settingVC.freqOsc = newFO
            }
            if (newOsc.intensityController != nil){
                let newIO = newOsc.intensityController as! Oscillator
            
                settingVC.intOsc = newIO
            }
            let newEg = mod.theBoard[1] as! EnvGenerator
            settingVC.eg = newEg
         //  exampleSynth.playSoundFromModule()
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return synths.count
    }
    private struct Storyboard{
        static let CellIdentifier = "FeedCell"
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath:indexPath) as! FeedCellView
        cell.synth = synths[indexPath.item]
        cell.Title.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        cell.Title.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.whiteColor()
        //cell.Title = UILabel()
        cell.Title.text = synths[indexPath.item].name
        return cell
    }
  }
