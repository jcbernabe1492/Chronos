//
//  ChronoTimer.swift
//  Kronos
//
//  Created by Wee, David G. on 8/24/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation

let TIME_INCREMENT_FAST = 1.0
let TIME_INCREMENT_DEFAULT = 0.1
let TIME_INCREMENT_MINUTE = 60.00
let TIME_INCREMENT_HOUR = 60.00 * 60.00

protocol TimerProtocol
{
    func secondPassed(newTime:Double)
    
    func updateTimerViewWithNewTime(time: Int)
}

class ChronoTimer:NSObject
{
    static var sharedInstance:ChronoTimer = ChronoTimer()
    var currentTimer:Timer?
    
    var currentMinutes:Int?
    var currentHours:Int?
    var currentTime:Double?
    var isActive:Bool = false
    var timeAppClosed:NSDate?
    var delegate:TimerProtocol?
    var delegates:[TimerProtocol] = []
    var second = 0
    
    //Starts New Timer
    func startNewTimer()
    {
        currentTime = 1.00
        currentHours = 0
        currentMinutes = 0
        startTimer()
    }
    
    //Starts Timer from previous Timer time
    func startTimer(time:Double)
    {
        currentTime = time
        currentMinutes = Int(time)
        currentHours = Int(time)/60
        startTimer()
    }
    
    //Starts Timer
    func startTimer()
    {
        currentTimer = Timer(timeInterval: TIME_INCREMENT_DEFAULT, target: self, selector: #selector(ChronoTimer.timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(currentTimer!, forMode: .commonModes)
        isActive = true
    }
    
    
    // Stops Timer
    func stopTimer()
    {
        currentTimer?.invalidate()
        if currentTime != nil {
            DataController.sharedInstance.updateCurrentJobTimer(timer: currentTime!)
        }
        isActive = false
    }
    
    

    //Gets the current time of Timer
    func getCurrentTime() -> Double
    {
        if currentTime == nil { return 0.0 }
        return currentTime!
    }
    
    //Aciton for timer, increases the value of time
    func timerAction()
    {
        currentTime = currentTime! + TIME_INCREMENT_DEFAULT
        DispatchQueue.global(qos: .background).async {
            print("currentTime: \(Int(self.currentTime!)), second: \(self.second)")
            if Int(self.currentTime!) > self.second
            {
                self.second = Int(self.currentTime!)
                DispatchQueue.main.async {
                    self.timerSecondAction(time:Double(self.second))
                }
            }
        }
    }
    
    func timerSecondAction(time:Double)
    {
        for d in delegates
        {
            if d != nil {
                d.secondPassed(newTime: time)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kSecondPassed"), object: nil)
    }
    
    func addtime(time:Int)
    {
        currentTime = currentTime!+Double(time*60)
        setTime(time: currentTime!)
        DataController.sharedInstance.updateCurrentJobTimer(timer: currentTime!)

    }
    func setTime(time:Double)
    {
        currentTime = time
        currentMinutes = Int(floor(Double(currentTime!/60)))
        currentHours = Int(floor(Double(currentMinutes!/60)))
    }
    
    func appWillClose()
    {
        if isActive
        {
            UserDefaults.standard.setValue(true, forKey: TIMER_IS_ON)
            UserDefaults.standard.setValue(NSDate(), forKey: "closeDate")
            DataController.sharedInstance.updateCurrentJobTimer(timer: currentTime!)
        }
        else
        {
             UserDefaults.standard.setValue(false, forKey: TIMER_IS_ON)
        }
    }
    
    
    
}
