//
//  CDCallback.swift
//  test
//
//  Created by Arvind Mehta on 07/04/23.
//

import Foundation
import SwiftyJSON
@objc public protocol CDCallback{
   
    func getLoginStatus(user:CDUser)
    func scanError(user:CDUser)
    func remaningTime(time:String,type:String)
    func scanStart(user:CDUser)
    func scanResponse(user:CDUser,cdscanResponse:CDDeviceResponse)
    func getPCFResponse(response:PCFResponse)
    func getVin(vin:String)
    func getRealTimePidResponse(pidName:String,value:String)
    
}
