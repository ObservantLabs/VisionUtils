//
//  File.swift
//  
//
//  Created by Alexis Gallagher on 2020-07-08.
//

import Foundation


func approximatelyEqual(jsonData jsonA:Data, otherJsonData jsonB:Data) -> Bool {
  guard
    let a = try? JSONSerialization.jsonObject(with: jsonA, options: []),
    let b = try? JSONSerialization.jsonObject(with: jsonB, options: []) else {
    return false
  }

  return approximatelyEqual(jsonAny: a, otherJsonAny: b)
}

fileprivate func approximatelyEqual(jsonAny a:Any,otherJsonAny b:Any) -> Bool
{
  switch (a,b) {
  case (let aDict as [String:Any], let bDict as [String:Any]):
    let (aKeys, bKeys) = (aDict.keys, bDict.keys)
    if Set(aKeys) != Set(bKeys) { return false }
    for aKey in aKeys {
      if !approximatelyEqual(jsonAny: aDict[aKey]!, otherJsonAny: bDict[aKey]!) {
        return false
      }
    }
    return true
  case (let aArray as [Any], let bArray as [Any]):
    let tuples = zip(aArray, bArray)
    for (aObject,bObject) in tuples.lazy {
      if !approximatelyEqual(jsonAny: aObject, otherJsonAny: bObject)  {
        return false
      }
    }
    return true
  case (let aNum as Double, let bNum as Double):
    return approximatelyEqual(a: aNum, b: bNum)
  case (let aString as String, let bString as String):
    return aString == bString
  case (is NSNull,is NSNull):
    return true
  default:
    return false
  }
}

fileprivate func approximatelyEqual(a:Double,b:Double) -> Bool {
  return a == b
}
