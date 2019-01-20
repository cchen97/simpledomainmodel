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
    
  public init(amount a: Int, currency c: String) {
        amount = a
        switch c {
        case "USD","GBP","EUR","CAN":
            currency = c
        default:
            currency = ""
            print("Currency is not acceptable")
        }
    }
  
  public func convert(_ to: String) -> Money {
    let target = to
    let from = currency
    let initial = amount
    var result : Int
    switch from {
    case "USD":
        switch target{
        case "GBP":
            result =  initial / 2
        case "EUR":
            result =  initial * 3 / 2
        case "CAN":
            result =  initial * 5 / 4
        default:
           result =  initial
        }
    case "GBP":
        switch target{
        case "USD":
            result =  initial * 2
        case "EUR":
            result =  initial * 3
        case "CAN":
            result =  initial * 5 / 2
        default:
            result =  initial
        }
    case "CAN":
        switch target{
        case "USD":
            result =  initial * 4 / 5
        case "EUR":
            result =  initial * 5 / 4
        case "GBP":
            result =  initial * 2 / 5
        default:
            result =  initial
        }
    default: //EUR
    switch target{
    case "USD":
        result =  initial * 2 / 3
    case "CAN":
        result =  initial * 4 / 5
    case "GBP":
        result =  initial / 3
    default:
        result =  initial
    }
    }
    return Money(amount: result, currency: target)
  }

  public func add(_ to: Money) -> Money {
    let a = amount
    let c = currency
    if to.currency != currency {
        let converted = Money(amount: a, currency: c).convert(to.currency)
        return Money(amount: converted.amount + to.amount, currency: to.currency)
    }
    return Money(amount: a + to.amount, currency: c)
  }
  public func subtract(_ from: Money) -> Money {
    let a = amount
    let c = currency
    if from.currency != currency {
        let converted = Money(amount: a, currency: c).convert(from.currency)
        return Money(amount:from.amount -  converted.amount, currency: from.currency)
    }
    return Money(amount: from.amount - a, currency: c)
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
    switch type {
    case .Hourly(let n):
        return Int(n * Double(hours))
    case .Salary(let n):
        return n
    }
  }

  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let n):
        type = JobType.Hourly(n + amt)
    case .Salary(let n):
        type = JobType.Salary(n + Int(amt))
    }
  }
}
//
//////////////////////////////////////
//// Person
////
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(newJob) {
        if age >= 16 {
            _job = newJob
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(newSpouse) {
        if age >= 18 {
            _spouse = newSpouse
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(_job?.type) spouse:\(_spouse?.firstName)]"
  }
}
//
//////////////////////////////////////
//// Family
////
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    if spouse1._spouse == nil && spouse2._spouse == nil {
        members.append(spouse1)
        members.append(spouse2)
    }
  }

  open func haveChild(_ child: Person) -> Bool {
    if members[0].age >= 21 || members[1].age >= 21 {
        members.append(child)
        return true
    }
    return false
  }

  open func householdIncome() -> Int {
    var result = 0
    for i in members {
        if i._job != nil{
            result = result + i.job!.calculateIncome(2000)
        }
    }
    return result
   }
}





