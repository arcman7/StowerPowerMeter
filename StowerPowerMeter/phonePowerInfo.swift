//
//  phonePowerInfo.swift
//  StowerPowerMeter
//
//  Created by Andrew Carpenter on 2/29/16.
//  Copyright (c) 2016 Andrew Carpenter. All rights reserved.
//
import Foundation
import UIKit
//import UIDevice

//helper functions

func roundToPlaces(value:Double, places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return round(value * divisor) / divisor
}

func stringFromTimeInterval(interval:Float) -> NSString {
    
    var ti = interval
    
    var ms = Int((interval % 1) * 1000)
    
    var seconds = ti % 60
    var minutes = (ti / 60) % 60
    var hours = (ti / 3600)

    return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
}

// func systemLogs() -> [[String: String]] {
//    let q = asl_new(UInt32(ASL_TYPE_QUERY))
//    var logs = [[String: String]]()
//    let r = asl_search(nil, q)
//    var m = asl_next(r)
//    while m != nil {
//        var logDict = [String: String]()
//        var i: UInt32 = 0
//        while true {
//            if let key = String.fromCString(asl_key(m, i)) {
//                let val = String.fromCString(asl_get(m, key))
//                logDict[key] = val
//                i++
//            } else {
//                break
//            }
//        }
//        m = asl_next(r)
//        logs.append(logDict)
//    }
//    asl_release(r)
//    return logs
//}


//helper classes & structs
struct powerInfo {
    var appName       : String
    var usagePercent  : Float
    
}

class helper {
    static let sharedInstance = helper()
    
    let device = UIDevice()
    
}


class PhonePowerInfo: NSObject {
    var mybatteryLevel: Float = 0.0
    
    let myHelper = helper.sharedInstance
    
    func getBatteryLevel() -> Float {
        return myHelper.device.batteryLevel
    }
    func getBatteryState() -> String {
        var states = [String]()
        states.append("Unkown"); states.append("Unplugged");
        states.append("Charging"); states.append("Full")
        var index: Int = myHelper.device.batteryState.rawValue

        return states[index]
    }


    override init() {
        super.init()
        self.myHelper.device.batteryMonitoringEnabled = true
        self.mybatteryLevel = getBatteryLevel()
        
    }
}


var phonePowerInfo = PhonePowerInfo()