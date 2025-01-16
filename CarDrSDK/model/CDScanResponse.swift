//
//  CDScanResponse.swift
//  test
//
//  Created by Arvind Mehta on 07/04/23.
//

import Foundation

@objc public class CDScanResponse: NSObject{
   public var dtcCode = ""
   public var dtcDesc  = ""
   public var dtcStatus = ""
}
@objc public class CDDeviceResponse : NSObject{
   public var vin = ""
    public var controllers = [String]()
   public var cdScanResponse:[CDScanResponse]? = nil
}
