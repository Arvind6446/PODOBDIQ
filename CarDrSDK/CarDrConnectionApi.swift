//
//  CarDrConnectionApi.swift
//  test
//
//  Created by Arvind Mehta on 07/04/23.
//

import Foundation

import Alamofire
import SwiftyJSON
import RepairClubSDK
import CoreBluetooth

 public class  CarDrConnectionApi: NSObject{
    
    
    public static let carDrApi = CarDrConnectionApi()
    let rc = RepairClubManager.shared
    
    
    //MARK  Intial function  to intialise the SDK
    public func initialConnect(){
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1,0"
            self.rc.configureSDK(tokenString: "1feddf76-3b99-4c4b-869a-74046daa3e30", appName: "OBDIQ ULTRA", appVersion: appVersion, userID: "")
        NotificationCenter.default.addObserver(self, selector: #selector(vehicleInfoNeededReceived(_:)), name:.vehicleInfoNeeded , object: nil)
        print("Connect Successfull")
        
        
        
    }
    
    @objc func vehicleInfoNeededReceived(_ notification: Notification) {
        guard let request = notification.object as? VehicleInfoRequest else { return }
        
        var message = ""
        switch request.reason {
        case .vinIncomplete:break
            
        case .vinMissing:break
           
        case .vehicleInfoNotFound:
            message = "We couldn't find the vehicle information. Please remove and reinsert the adapter in the vehicle OBD port; ensuring the device is fully inserted and the engine is running."
          
        case .serverUnavailable:
            message = "We couldn't find the vehicle information. Please remove and reinsert the adapter in the vehicle OBD port; ensuring the device is fully inserted and the engine is running."
           
        case .accessLocked:
            message = "Access to vehicle data appears to be locked. Please start the vehicle with the key and ensure the device is firmly connected."
            
        case .busMissing:
            message = "We care unable to connect. Please remove and reinsert the adapter in the vehicle OBD port; ensuring the device is fully inserted and the engine is running."
           
        case .busConnectionTrouble:
            message = "We care unable to connect. Please remove and reinsert the adapter in the vehicle OBD port; ensuring the device is fully inserted and the engine is running."
            
        case .noDevicesFound:
            message = "No Device found. Please remove and reinsert the adapter in the vehicle OBD port; ensuring the device is fully inserted and the engine is running."
            
        @unknown default:
            message = "We've encountered an unexpected issue. Please remove and reinsert the adapter in the vehicle OBD port; ensuring the device is fully inserted and the engine is running."
            
        }
    }
    
    
    
    //MARK  Clear code functionality
    
    func  clearCode(completion:@escaping ( OperationProgressUpdate) -> Void){
        
        self.rc.clearAllCodes { progress in
            completion(progress)
            
        }
    }
    
    //MARK  Call this function to disconnect the Mobile device with OBD adapter
    func dissconnectOBD(){
        self.rc.stopTroubleCodeScan()
        self.rc.disconnectFromDevice()
        
    }
    
    
    func scanForDevice() {
            rc.returnDevices { result in
                switch result {
                case .success(let devices):
                    print(devices)
                  
                    if let nearestDevice = devices.sorted(by: { $0.rssi >
                        $1.rssi }).first {

                        self.connectPeripheral(peripheral: nearestDevice.device)
                    }
                    break
                case .failure(let error):
                    break
                @unknown default:break
                    
                }
            }

    }
    
    
    //MARK   Connect OBD using bluetooth
    //  vehicleEntry  Obj  will return the vehical related data
    func connectPeripheral(peripheral:CBPeripheral?){
        
      
        if(peripheral == nil){
            return
        }
  
        self.rc.connectToDevice(peripheral: peripheral!) { [self] connectionEntry, connectionstage, connectionState in
            switch connectionstage {
            case .deviceHandshake:
                print("Connection: deviceHandshake - \(connectionState)")
                switch connectionState {
                case .completed:
                    if let device = connectionEntry.deviceItem{
                       let hardwareIdentifier = device.hardwareIdentifier ?? device.deviceIdentifier
                    }
                
                    
                default: break
                }
                
                 
            case .mainBusFound:
                    print("Connection: mainBusFound - \(connectionState)")
            case .vinReceived:
                    print("Connection: vinReceived - \(connectionState)")
            case .vehicleDecoded:
                                 if let vehicleEntry = connectionEntry.vehicleEntry {
                                  
                                    let make = vehicleEntry.make
                                     let model = vehicleEntry.model
                                     let year = vehicleEntry.yearString
                                    
                                     let vinNumber = vehicleEntry.VIN
                                   
                                 } else if let vin = connectionEntry.vin {
                                     let vinNumber = vin
                                 }
            case .configDownloaded:
                print("Connection: configDownloaded - \(connectionState)")
                switch connectionState {
                case .completed:print("Complete")
                    
                case .failed (let error):break
                     
                case .manuallyEntered, .started, .notStarted: break
                   
                @unknown default:break
                  
                   
                }
               
            case .busSyncedToConfig:
                print("Connection: busSyncedToConfig - \(connectionState)")
                switch connectionState {
                case .completed:break
                    
                case .failed(let error):break
                    
                    
                case .manuallyEntered, .started, .notStarted: break
                    
                @unknown default:break
                    
                }
               
            case .milChecking:
                print("Connection: milChecking - \(connectionState)")
                                 if connectionState == .completed, let milON =
                 connectionEntry.milOn {
                                    
                                 }
            case .readinessMonitors:
                print("Connection: readinessMonitors - \(connectionState)")
            case .supportedPIDsReceived:
                print("Connection: supportedPIDsReceived - \(connectionState)")
            case .supportedMIDsReceived:
                print("Connection: supportedMIDsReceived - \(connectionState)")
            case .odometerReceived:print("Connection: ODOMETER - \(connectionEntry.odometer)")
                
            @unknown default: break
               
            }
        }
        
        
    }
    
    
    
    
    //MARK  Call this function  to get the Vehical Detail
    func getVehical(vin:String){
        self.rc.requestVinDetailDecode(for: vin) { result in
            switch result {
            case .success:
                do {
                    // Attempt to get the result and filter out entries where the value is empty
                     let vinDetailResult = try result.get().toMap().filter { !$0.value.isEmpty }
                    
                    // Sort the filtered dictionary alphabetically by keys
                    let sortedVinDetailResult = vinDetailResult.sorted { $0.key < $1.key }
                    
                    // Use sortedVinDetailMap as needed
                } catch {
                    print("Error: \(error)")
                }
              

            case .failure:break
                

            default:
                print("Unexpected result")
            }

        }
    }
    
    
    
    func startAdvanceScan(advancescan:Bool = true) {
      
        rc.startTroubleCodeScan(advancedScan: advancescan) { [self] progressupdate in
            switch progressupdate {
                
            case .scanStarted: break
            case .progressUpdate(let progress):
              
                var per = ceil(progress*100)/100
                
                let percent = String(format: "%.2f", per * 100)
            
            case .moduleScanningUpdate(moduleName: let moduleName):
                print("ModuleName ======= \(moduleName)")
            case .modulesUpdate(modules: let modulesUpdate):
                var modules = modulesUpdate.sorted(by: {
                    // Prioritize modules with "Generic Codes" in their name
                    if $0.name.contains("Generic Codes") { return true }
                    if $1.name.contains("Generic Codes") { return false }
                    let responseOrder: [ResponseStatus: Int] = [.responded:
                                                                    1, .awaitingDecode: 2, .didNotRespond: 3, .unknown: 4]
                    if responseOrder[$0.responseStatus]! <
                        responseOrder[$1.responseStatus]! { return true }
                    if responseOrder[$0.responseStatus]! >
                        responseOrder[$1.responseStatus]! { return false }
                    
                    if !$0.codes.isEmpty && $1.codes.isEmpty { return true }
                    if $0.codes.isEmpty && !$1.codes.isEmpty { return  false }
                    
                    return $0.name < $1.name
                    
                })
                
            case .scanSucceeded(scanEntry: let scanEntry, modules: let modulesUpdate, errors: let errors):
                var modules = modulesUpdate.sorted(by: {
                    if $0.name.contains("Generic Codes") { return true }
                    
                    if $1.name.contains("Generic Codes") { return false }
                    
                    let responseOrder: [ResponseStatus: Int] = [.responded:
                                                                    1, .awaitingDecode: 2, .didNotRespond: 3, .unknown: 4]
                    if responseOrder[$0.responseStatus]! <
                        responseOrder[$1.responseStatus]! { return true }
                    if responseOrder[$0.responseStatus]! >
                        responseOrder[$1.responseStatus]! { return false }
                    
                    if !$0.codes.isEmpty && $1.codes.isEmpty { return true }
                    if $0.codes.isEmpty && !$1.codes.isEmpty { return false}
                    // Finally, sort alphabetically
                    return $0.name < $1.name
                })
               
                let codesCount = modules.reduce(0) { $0 + $1.codes.count }
               
                       
                // Get distinct modules by name
             
                        // Get distinct modules by name
                        let distinctModules = modules.distinctBy { $0.name }
                        
                        for module in distinctModules {
                            let moduleName = module.name
            
                            // Get distinct codes and map to Response
                            let codesList = module.codes
                                .distinctBy { $0.code }
                                .map { code in
                                  
                                   
                                }
                            
                           
                            
                        }
                        
                
                let result = self.rc.getDeviceFirmwareVersion()
                do{
                    let firmwareversion = try result.get() ?? ""
                }catch{
                    
                }
              
              
                getEmissionResult()
              
                
                
            case .scanFailed(errors: let errors):break
             
            @unknown default: break
                
            }
        }
    }

    private func sortModules(modules: [RepairClubSDK.ModuleItem]) -> [RepairClubSDK.ModuleItem] {
        return modules.sorted {
            if $0.name.contains("Generic Codes") { return true }
            if $1.name.contains("Generic Codes") { return false }
            
            let responseOrder: [ResponseStatus: Int] = [.responded: 1, .awaitingDecode: 2, .didNotRespond: 3, .unknown: 4]
            if responseOrder[$0.responseStatus]! < responseOrder[$1.responseStatus]! { return true }
            if responseOrder[$0.responseStatus]! > responseOrder[$1.responseStatus]! { return false }
            
            if !$0.codes.isEmpty && $1.codes.isEmpty { return true }
            if $0.codes.isEmpty && !$1.codes.isEmpty { return false }
            
            return $0.name < $1.name
        }
    }

    private func handleModulesUpdate(modules: [RepairClubSDK.ModuleItem]) {
        // Handle module updates here if needed
    }

    func getEmissionResult(){
        rc.subscribeToMonitors { str in
            do {
              
                let data = try str.get()
                data.forEach { monitor in
                  
                }
             
               
            } catch {
                // Handle error here
            }
            
            
        }
        rc.requestMonitors()
    }
    
    func stopAdvanceScan(){
        self.rc.stopTroubleCodeScan()
    }
    

    //MARK  This Function to update the Firmware
    // NOTE  This function  only call after the OBD connected successfully  and any type of scan not run
    func updateFirmware(completion: @escaping (String) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { timer in
            var result = self.rc.getNewestAvailableFirmwareVersion()
             var currnt = "2.018.20"
         
            do{
                currnt = try result.get() ?? "2.018.20"
            }catch{
                
            }
         
          
    
            self.rc.startDeviceFirmwareUpdate(reqVersion: currnt,reqReleaseLevel: .production)
        }
    }
   
    
    func stopFirmware(){
        self.rc.stopDeviceFirmwareUpdate()
    }
    
    

    
    
}
extension VINDetailResult {
    func toMap() -> [String: String] {
        var resultMap = [String: String]()
        let mirror = Mirror(reflecting: self)

        for child in mirror.children {
            if let propertyName = child.label,
               let propertyValue = child.value as? CustomStringConvertible {
                let valueString = propertyValue.description
                if !valueString.isEmpty {
                    resultMap[propertyName] = valueString
                }
            }
        }

        return resultMap
    }
}
extension Array {
    func distinctBy<T: Hashable>(_ key: (Element) -> T) -> [Element] {
        var seen: Set<T> = []
        return self.filter { element in
            let keyValue = key(element)
            return seen.insert(keyValue).inserted
        }
    }
}
