//
//  ViewController.swift
//  ImageFinal
//
//  Created by sang on 27/5/23.
//

import UIKit
import Foundation
import CoreBluetooth


class ViewController: UIViewController ,   CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource{
    var coreCenter = CBCentralManager();
    private var centralManager: CBCentralManager?
          private var discoveredPeripherals: [CBPeripheral] = []
    //cnc
      var manager:CBCentralManager!
      var peripheral:CBPeripheral!

      let BEAN_NAME = "AC695X_1(BLE)"
      var myCharacteristic : CBCharacteristic!
          
          var isMyPeripheralConected = false

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableview.dataSource = self
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        tableview.delegate = self
        tableview.dataSource = self
        manager = CBCentralManager(delegate: self, queue: nil)
        
    }

    @objc func centralManagerDidUpdateState(_ central: CBCentralManager) {
                                if central.state == .poweredOn {
                                    if let peripheral = peripheral {
                                                if peripheral.state == .connected {
                                                    // The peripheral is connected
                                                    print("Peripheral is connected.")
                                                } else {
                                                    // The peripheral is not connected
                                                    print("Peripheral is not connected.")
                                                    central.scanForPeripherals(withServices: nil, options: nil)
                                                }
                                            } else {
                                                // No peripheral is currently assigned
                                                print("No peripheral assigned.")
                                                central.scanForPeripherals(withServices: nil, options: nil)
                                            }
                                    
                                } else {
                                    print("Bluetooth is not available.")
                                }
                            }
                    func cancelPeripheralConnection(_ peripheral: CBPeripheral)
                    {
                        
                        discoveredPeripherals.dropFirst()
                        print("discc")
                    }
                       func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
                                  if !discoveredPeripherals.contains(peripheral) {
                                     
                                      discoveredPeripherals.append(peripheral)
                                      tableview.reloadData()
                                      
                                  }
                                 
                           
                           
                                //  print(mainflagg.description)
                                  if peripheral.name?.contains("AC695X_1(BLE)") == true {
                                     
                                      manager.cancelPeripheralConnection(peripheral)
                                      manager.cancelPeripheralConnection(peripheral)
                                     
                                   
                                              self.peripheral = peripheral
                                              self.peripheral.delegate = self

                                              manager.connect(peripheral, options: nil)
                                      peripheral.delegate = self
                                      peripheral.discoverServices(nil)
                                   
                                              print("My  discover peripheral", peripheral)
                                      self.manager.stopScan()
                      //check pherifiral
                                     
                                      
                                      
                                          }
                                  
                                  
                                  
                       }
                    func cancelConnection() {
                        //peripheral.writeValue(x, for: y, type: .withResponse)
                    }
                       //
                       // MARK: - UITableViewDelegate & UITableViewDataSource
                     @objc  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                          let peripheral = discoveredPeripherals[indexPath.row]
                          let devicename = peripheral.identifier.uuidString
                        
                     
                         let sec = storyboard?.instantiateViewController(identifier: "wifi") as! WifiListViewer
                                                        present(sec,animated: true)
                         
                          
                      }
                          
                        @objc   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                             /// print("se")
                              return discoveredPeripherals.count
                          }
                          
                         @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                              let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                              let peripheral = discoveredPeripherals[indexPath.row]
                              cell.textLabel?.text = peripheral.name ?? "Unknown Device"
                              cell.detailTextLabel?.text = peripheral.identifier.uuidString
                            
                              return cell
                          }
                      func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
                          if let error = error {
                              print("Failed to connect to peripheral: \(error.localizedDescription)")
                          } else {
                              print("Failed to connect to peripheral")
                          }
                          // Perform any necessary error handling or recovery steps
                      }
                     
                      
                      
                     @objc  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
                               isMyPeripheralConected = true //when connected change to true
                               peripheral.delegate = self
                               peripheral.discoverServices(nil)
                           
                       
                         print("Connected  \(peripheral.name)")
                           var statusMessage = "Connected Successfully with this device : "+BEAN_NAME.description
                         
                           
                           
                     }
                    
                    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
                              isMyPeripheralConected = false //and to falso when disconnected
                              var statusMessage = "Can't  connected with this device : "+BEAN_NAME.description
                            
                        print("Disconnect \(error.debugDescription)")
                          }
                      func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
                          print("not connect")
                      }
                       
                       func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
                                    guard let services = peripheral.services else { return }
                                    
                                    for service in services {
                                      peripheral.discoverCharacteristics(nil, for: service)
                                        print("Discoveri")
                                    }
                                }
                       private var printerCharacteristic: CBCharacteristic!
                       func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
                                   guard let characteristics = service.characteristics else { return }
                                   
                                   for characteristic in characteristics {
                                       if characteristic.properties.contains(.writeWithoutResponse) {
                                           printerCharacteristic = characteristic
                                           //image select
                                           
                                          let newImage = convertImageToDifferentColorScale(with: UIImage(named: "sma")!, imageStyle: "CIPhotoEffectNoir")
                                           
                                           ///covertToGrayScale(with: newImage,cph: peripheral, charch: printerCharacteristic)
                                          /// print("char me "+printerCharacteristic.debugDescription)
                                           covertToGrayScalezAngenl2(with: newImage, cph: peripheral, charch: characteristic)
                                           
                                           var tttui = " \r\n\n\n"
                                                                      print(characteristic)
                                           guard let data = tttui.data(using: .utf8) else { return }
                                           
                                                                      
                                            peripheral.writeValue(data, for: printerCharacteristic, type: .withoutResponse)
                                           
                                          
                                           break
                                       }
                                   }
                       }
  /*
   func covertToGrayScale(with image: UIImage,  cph : CBPeripheral, charch : CBCharacteristic) -> Data? {
         
          let width = Int(image.size.width)
          let height = Int(image.size.height)
       print("good"+width.description+""+height.description)
          // Pixels will be drawn in this array
          var pixels = [UInt32](repeating: 0, count: width * height)
          
          let colorSpace = CGColorSpaceCreateDeviceRGB()
          
          // Create a context with pixels
          guard let context = CGContext(data: &pixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
              return nil
          }
          
          context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
          
          var tt = 1
          var bw = 0
          var bytes = [UInt8](repeating: 0, count: width / 8 * height)
          var p = [Int](repeating: 0, count: 8)
          
          for y in 0..<height {
              for x in 0..<(width / 8) {
                  for z in 0..<8 {
                      let rgbaPixel = pixels[y * width + x * 8 + z]
                      
                      let red = (rgbaPixel >> 16) & 0xFF
                      let green = (rgbaPixel >> 8) & 0xFF
                      let blue = rgbaPixel & 0xFF
                      let gray = 0.299 * Double(red) + 0.587 * Double(green) + 0.114 * Double(blue) // Grayscale conversion formula
                      
                      if gray <= 128 {
                          p[z] = 0
                      } else {
                          p[z] = 1
                      }
                  }
                  
                  let value = p[0] * 128 + p[1] * 64 + p[2] * 32 + p[3] * 16 + p[4] * 8 + p[5] * 4 + p[6] * 2 + p[7]
                  bytes[bw] = UInt8(value)
                  bw += 1
              }
          }
       var commandData = Data()
          commandData.append(contentsOf: [0x1B, 0x40]) // Initialize printer
          commandData.append(contentsOf: [0x1B, 0x4D, 0x00]) // Set printing density
          commandData.append(contentsOf: [0x1D, 0x76, 0x30, 0x00]) // Select image mode (bit-image mode)
          
          let imageWidth = width / 8
          let imageHeight = height
          let imageSizeCommand = [0x1D, 0x76, 0x30, UInt8(imageWidth), UInt8(imageHeight)]
          commandData.append(contentsOf: imageSizeCommand)
          
          commandData.append(contentsOf: bytes)
       
          //let data = Data(bytes: bytes)
         print("Good"+commandData.debugDescription)
       print("Second : "+charch.debugDescription)
       cph.writeValue(commandData, for: charch, type: .withoutResponse)
         
       return commandData;
      }
   */
                           
                          
    var context = CIContext(options: nil)
          func convertImageToDifferentColorScale(with originalImage:UIImage, imageStyle:String) -> UIImage {
              let currentFilter = CIFilter(name: imageStyle)
              currentFilter!.setValue(CIImage(image: originalImage), forKey: kCIInputImageKey)
              let output = currentFilter!.outputImage
              let context = CIContext(options: nil)
              let cgimg = context.createCGImage(output!,from: output!.extent)
              let processedImage = UIImage(cgImage: cgimg!)
              return processedImage
          }
    
    
    func covertToGrayScale(with image: UIImage,  cph : CBPeripheral, charch : CBCharacteristic) -> Data? {
              
               let width = Int(image.size.width)
               let height = Int(image.size.height)
            print("good"+width.description+""+height.description)
               // Pixels will be drawn in this array
               var pixels = [UInt32](repeating: 0, count: width * height)
               
               let colorSpace = CGColorSpaceCreateDeviceRGB()
               
               // Create a context with pixels
               guard let context = CGContext(data: &pixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
                   return nil
               }
               
               context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
               
               var tt = 1
               var bw = 0
               var bytes = [UInt8](repeating: 0, count: width / 8 * height)
               var p = [Int](repeating: 0, count: 8)
               
               for y in 0..<height {
                   for x in 0..<(width / 8) {
                       for z in 0..<8 {
                           let rgbaPixel = pixels[y * width + x * 8 + z]
                           
                           let red = (rgbaPixel >> 16) & 0xFF
                           let green = (rgbaPixel >> 8) & 0xFF
                           let blue = rgbaPixel & 0xFF
                           let gray = 0.299 * Double(red) + 0.587 * Double(green) + 0.114 * Double(blue) // Grayscale conversion formula
                           
                           if gray <= 128 {
                               p[z] = 0
                           } else {
                               p[z] = 1
                           }
                       }
                       
                       let value = p[0] * 128 + p[1] * 64 + p[2] * 32 + p[3] * 16 + p[4] * 8 + p[5] * 4 + p[6] * 2 + p[7]
                       bytes[bw] = UInt8(value)
                       bw += 1
                   }
               }
            var commandData = Data()
               commandData.append(contentsOf: [0x1B, 0x63,0x30,0x02]) // Initialize printer
               commandData.append(contentsOf: [0x1B, 0x4D, 0x00]) // Set printing density
               commandData.append(contentsOf: [0x1D, 0x76, 0x30, 0x00]) // Select image mode (bit-image mode)
               
               let imageWidth = width / 8
               let imageHeight = height
               let imageSizeCommand = [0x1D, 0x76, 0x30, UInt8(imageWidth), UInt8(imageHeight)]
               commandData.append(contentsOf: imageSizeCommand)
               
               commandData.append(contentsOf: bytes)
            
               //let data = Data(bytes: bytes)
              print("Good"+commandData.debugDescription)
        print("Getten ID : "+charch.debugDescription)
            cph.writeValue(commandData, for: charch, type: .withoutResponse)
              
            return commandData;
           }
    
    
    
    func covertToGrayScalezAngenl(with image: UIImage,  cph : CBPeripheral, charch : CBCharacteristic) -> Data? {
              
               let width = 160//Int(image.size.width)
               let height = 160//Int(image.size.height)
            print("good"+width.description+""+height.description)
               // Pixels will be drawn in this array
               var pixels = [UInt32](repeating: 0, count: width * height)
               
               let colorSpace = CGColorSpaceCreateDeviceRGB()
               
               // Create a context with pixels
               guard let context = CGContext(data: &pixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
                   return nil
               }
        // Calculate the centered origin for drawing the image
            let originX = (width - Int(image.size.width)) / 2
            let originY = (height - Int(image.size.height)) / 2
            
               
               context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
               
               var tt = 1
               var bw = 0
               var bytes = [UInt8](repeating: 0, count: width / 8 * height)
               var p = [Int](repeating: 0, count: 8)
               
               for y in 0..<height {
                   for x in 0..<(width / 8) {
                       for z in 0..<8 {
                           let rgbaPixel = pixels[y * width + x * 8 + z]
                           
                           let red = (rgbaPixel >> 16) & 0xFF
                           let green = (rgbaPixel >> 8) & 0xFF
                           let blue = rgbaPixel & 0xFF
                           let gray = 0.299 * Double(red) + 0.587 * Double(green) + 0.114 * Double(blue) // Grayscale conversion formula
                           
                           if gray <= 128 {
                               p[z] = 0
                           } else {
                               p[z] = 1
                           }
                       }
                       
                       let value = p[0] * 128 + p[1] * 64 + p[2] * 32 + p[3] * 16 + p[4] * 8 + p[5] * 4 + p[6] * 2 + p[7]
                       bytes[bw] = UInt8(value)
                       bw += 1
                   }
               }
            var commandData = Data()
        
        commandData.append(0x1D)
        commandData.append(0x0E)
        commandData.append(0x1C)
        commandData.append(0x60)
             
        commandData.append(0x4D)
           
        commandData.append(0x53)
        let new_valesS = UInt8(3)
        commandData.append(new_valesS)
        commandData.append(0x1C)   //command use cpcl
        commandData.append(0x60)
        commandData.append(0x7E)
        commandData.append(0x7E)
        let new_valesSN = UInt8(16)
        commandData.append(new_valesSN)
        commandData.append(0x1D)
        commandData.append(0x76)
        commandData.append(0x30)
        commandData.append(0x00)
                let widthX  = 160
                let heightX = 160
                let widthL=widthX/8%256
                let widthH=widthX/8/256
                let heightL=heightX%256
                let heightH=heightX/256
                let valrues: [UInt8] = [1, 2, 3, 4]
               let new_vales1 = UInt8(widthL)
        commandData.append(new_vales1)
                let new_vales2 = UInt8(widthH)
        commandData.append(new_vales2)
               let  new_vales3 = UInt8(heightL)
        commandData.append(new_vales3)
               let  new_vales4 = UInt8(heightH)
        commandData.append(new_vales4)
        
        
        
        

               commandData.append(contentsOf: bytes)
        commandData.append(0x1C)
        commandData.append(0x5E)
        print(commandData)
        //let data = Data(bytes: bytes)
             // print("Good"+commandData.debugDescription)
        //print("Getten ID : "+charch.debugDescription)
            cph.writeValue(commandData, for: charch, type: .withoutResponse)
        ////print(commandData)
              
            return commandData;
           }
    func covertToGrayScalezAngenl2(with image: UIImage,  cph : CBPeripheral, charch : CBCharacteristic) -> Data? {
              
               let width = 255//Int(image.size.width)
               let height = 255//Int(image.size.height)
            print("good"+width.description+""+height.description)
               // Pixels will be drawn in this array
               var pixels = [UInt32](repeating: 0, count: width * height)
               
               let colorSpace = CGColorSpaceCreateDeviceRGB()
               
               // Create a context with pixels
               guard let context = CGContext(data: &pixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
                   return nil
               }
        // Calculate the centered origin for drawing the image
            let originX = (width - Int(image.size.width)) / 2
            let originY = (height - Int(image.size.height)) / 2
            
               
               context.draw(image.cgImage!, in: CGRect(x: 70, y: 0, width: width, height: height))
               
               var tt = 1
               var bw = 0
               var bytes = [UInt8](repeating: 0, count: width / 8 * height)
               var p = [Int](repeating: 0, count: 8)
               
               for y in 0..<height {
                   for x in 0..<(width / 8) {
                       for z in 0..<8 {
                           let rgbaPixel = pixels[y * width + x * 8 + z]
                           
                           let red = (rgbaPixel >> 16) & 0xFF
                           let green = (rgbaPixel >> 8) & 0xFF
                           let blue = rgbaPixel & 0xFF
                           let gray = 0.299 * Double(red) + 0.587 * Double(green) + 0.114 * Double(blue) // Grayscale conversion formula
                           
                           if gray <= 128 {
                               p[z] = 0
                           } else {
                               p[z] = 1
                           }
                       }
                       
                       let value = p[0] * 128 + p[1] * 64 + p[2] * 32 + p[3] * 16 + p[4] * 8 + p[5] * 4 + p[6] * 2 + p[7]
                       bytes[bw] = UInt8(value)
                       bw += 1
                   }
               }
            var commandData = Data()
        
        commandData.append(0x1D)
        commandData.append(0x0E)
        commandData.append(0x1C)
        commandData.append(0x60)
             
        commandData.append(0x4D)
           
        commandData.append(0x53)
        let new_valesS = UInt8(3)
        commandData.append(new_valesS)
        commandData.append(0x1C)   //command use cpcl
        commandData.append(0x60)
        commandData.append(0x7E)
        commandData.append(0x7E)
        let new_valesSN = UInt8(16)
        commandData.append(new_valesSN)
        commandData.append(0x1D)
        commandData.append(0x76)
        commandData.append(0x30)
        commandData.append(0x00)
                let widthX  = 255
                let heightX = 255
                let widthL=widthX/8%256
                let widthH=widthX/8/256
                let heightL=heightX%256
                let heightH=heightX/256
                let valrues: [UInt8] = [1, 2, 3, 4]
               let new_vales1 = UInt8(widthL)
        commandData.append(new_vales1)
                let new_vales2 = UInt8(widthH)
        commandData.append(new_vales2)
               let  new_vales3 = UInt8(heightL)
        commandData.append(new_vales3)
               let  new_vales4 = UInt8(heightH)
        commandData.append(new_vales4)
        
        
        
        

               commandData.append(contentsOf: bytes)
        commandData.append(0x1C)
        commandData.append(0x5E)
        print(commandData)
        //let data = Data(bytes: bytes)
             // print("Good"+commandData.debugDescription)
        //print("Getten ID : "+charch.debugDescription)
            cph.writeValue(commandData, for: charch, type: .withoutResponse)
        ////print(commandData)
              
            return commandData;
           }
}

