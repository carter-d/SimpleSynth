//
//  FeedViewController.swift
//  SimpleSynth
//
//  Created by Estee Rebibo on 11/20/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate
{
   

   
    @IBOutlet weak var feedCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    var synths = [ModuleBoard]();
    var index = -1
    var exampleSynth = Synth() 
    
    override func viewDidLoad() {
      
        activityInd.hidesWhenStopped = true
        self.feedCollectionView.dataSource = self
        self.feedCollectionView.delegate = self
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
            if (index == indexPath.row){
                 exampleSynth.pausePlayer()
            }
            else{
                index = indexPath.row
            let mod = synths[index]
            exampleSynth.mb = mod
            exampleSynth.playSoundFromModule()
            }
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
        return cell
    }
    



}
