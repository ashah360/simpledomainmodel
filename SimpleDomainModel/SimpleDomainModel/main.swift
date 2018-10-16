//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var usdValue = 0;
    switch currency {
    case "EUR":
        usdValue = amount * 2 / 3
    case "GBP":
        usdValue = amount * 2
    }
    case "CAN":
        usdValue = amount * 4 / 5
    default:
        usdValue = amount
    
    switch to {
    case "USD":
        return Money(amount: usdValue, currency: "USD")
    case "EUR":
        return Money(amount: (usdValue * 3)/2, currency: "EUR")
    case "GBP":
        return Money(amount: usdValue/2, currency: "GBP")
    case "CAN":
        return Money(amount: (usdValue * 5)/4, currency: "CAN")
    default:
        return Money(amount: amount, currency: currency)
    }
  }
  
  public func add(_ to: Money) -> Money {
    let convertedCurr = self.convert(to.currency);
    let newAmt = convertedCurr.amount + to.amount
    return Money(amount: newAmt, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    let convertedCurr = self.convert(from.currency)
    let newAmt = from.amount - convertedCurr.amount
    return Money(amount: newAmt, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case JobType.Hourly(let value):
        return Int(value * Double(hours))
    case JobType.Salary(let value):
        return value
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case JobType.Hourly(let value):
        self.type = JobType.Hourly(value + amt)
    }
    case JobType.Salary(let value):
        self.type = JobType.Salary(value + Int(amt))
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {return self._job}
    set(value) {
        if self.age >=16 {
            self._job = value
        }
        else {
            return
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {return self._spouse}
    set(value) {
        if self.age >=18 {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: _job)) spouse:\(String(describing: _spouse))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        // set spouses
        spouse1.spouse = spouse2
        members.append(spouse1)
        spouse2.spouse = spouse1
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    // if the first spouse and the second pouse are both 21 or older
    if members[0].age >= 21 || members[1].age >= 21 {
        members.append(child)
        return true
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var total: Int = 0
    for member in members {
        // if they have a job
        if member.job != nil {
            switch member.job!.type {
            case Job.JobType.Salary(let value):
                total += value
            case Job.JobType.Hourly(let value):
                total += Int(value * 2000)
            }
        }
    }
    return total
  }
}





