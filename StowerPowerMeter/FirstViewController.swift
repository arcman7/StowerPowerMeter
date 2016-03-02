//
//  FirstViewController.swift
//  StowerPowerMeter
//
//  Created by Andrew Carpenter on 2/28/16.
//  Copyright (c) 2016 Andrew Carpenter. All rights reserved.
//

import UIKit
import Foundation


class FirstViewController: UIViewController {
    
    //labels
    @IBOutlet var batteryStatus  : UILabel!
    @IBOutlet var percPerSec     : UILabel!
    @IBOutlet var timeToCharge   : UILabel!
    @IBOutlet var remaining      : UILabel!
    @IBOutlet var percentageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "batteryStateDidChange:", name: UIDeviceBatteryStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "batteryLevelDidChange:", name: UIDeviceBatteryLevelDidChangeNotification, object: nil)
        percentageLabel.text = "\(phonePowerInfo.getBatteryLevel())"
        timeNew = CFAbsoluteTimeGetCurrent()
        self.batteryStatus.hidden = true
        self.percPerSec.hidden = true
        self.timeToCharge.hidden = true
        self.remaining.hidden = true
        self.percentageLabel.hidden = true
    }
    
    func batteryStateDidChange(notification: NSNotification){
        batteryStatus.text = "Charging Status: \(phonePowerInfo.getBatteryState())"
        batteryStatus.hidden = false
        //hide labels about charge rate if phone is not plugged in
        var unplugged: Bool = (phonePowerInfo.getBatteryState() == "Unplugged")
        var unknown:   Bool = (phonePowerInfo.getBatteryState() == "Unknown")
        if( unplugged || unknown){
            timeToCharge.hidden = true
            //percPerSec.hidden   = true //phone can be losing power
        }
        var charging: Bool = chargingState == "Charging"
        var complete: Bool = chargingState == "Complete"
        //need to check if 1% has changed
        if(self.hasChanged){
          if(charging){
            time2Charge = ( 100.00 - phonePowerInfo.getBatteryLevel() ) * (secondsPerPercentage)
            timeToCharge.text = "Time to full charge: \(stringFromTimeInterval(time2Charge))"
            timeToCharge.hidden = false

          }
          else if(complete){
            timeToCharge.text = "Charge complete"
            timeToCharge.hidden = false
          }
        }
        
    }
    
//    Watt is the unit of power (symbol: W). The watt unit is named after James Watt, the inventor of the steam engine. One watt is defined as the energy consumption rate of one joule per second. One watt is also defined as the current flow of one ampere with voltage of one volt.
//  ampere hour = 3600 coulombs
//  1.715mAh = (3600/1000)*1.75 
    
    func batteryLevelDidChange(notification: NSNotification){
        // The battery's level did change (98%, 99%, ...)
        percentageLabel.text = "\(phonePowerInfo.getBatteryLevel())"
        timeOld = timeNew
        timeNew = CFAbsoluteTimeGetCurrent()
        timeElapsed = timeNew - timeOld //units of seconds
        secondsPerPercentage =  Float( roundToPlaces(timeElapsed,2) )
        percentagePerSecond = (1.0 / secondsPerPercentage)
        percPerSec.text = "\(secondsPerPercentage) seconds to charge 1%"
        percPerSec.hidden = false
        
        if(!hasChanged){
          hasChanged = true
        }
        var charging: Bool = chargingState == "Charging"
        if(charging){
            time2Charge = ( 100.00 - phonePowerInfo.getBatteryLevel() ) * (secondsPerPercentage)
            timeToCharge.text = "Time to full charge: \(stringFromTimeInterval(time2Charge))"
            timeToCharge.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //time tracking
    
    
    var timeOld:     Double = 0.0
    var timeNew:     Double = 0.0
    var timeElapsed: Double = 0.0
    var time2Charge: Float  = 0.0
    var percentagePerSecond:  Float  = 0.0
    var secondsPerPercentage: Float  = 0.0
    //charging State
    var chargingState: String {
        get{
            return phonePowerInfo.getBatteryState()//computate property
        }
    }
    var hasChanged: Bool = false
}

