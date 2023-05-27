//
//  ImageTextingViewe.swift
//  ImageFinal
//
//  Created by sang on 27/5/23.
//

import UIKit

class ImageTextingViewe: UIViewController {

    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var imageClicked: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func clikkk(_ sender: UIButton) {
        let newImage = convertImageToDifferentColorScale(with: UIImage(named: "sma")!, imageStyle: "CIPhotoEffectNoir")
    convert()
        
        
      /*
       let newImage = convertImageToDifferentColorScale(with: UIImage(named: "sma")!, imageStyle: "CIPhotoEffectNoir")
       
       guard let image = UIImage(named: "sma") else {
           // Handle error when image is not found
           return
       }

       guard let imageData = image.pngData() else {
           // Handle error when converting image to data
           return
       }

       let byteArray = [UInt8](imageData)
       //print(byteArray)
       
     
       let drrata = Data(bytes: byteArray)
       guard let imagee = UIImage(data: drrata) else {
           // Handle error when converting data to image
           print("Mainerror")
           return
       }
       print(imageData)
   secondImage.image = imagee
 covertToGrayScale(with: image)
       */

    }
    func convert()
    {
        let newImage = convertImageToDifferentColorScale(with: UIImage(named: "sma")!, imageStyle: "CIPhotoEffectNoir")
        guard let image = UIImage(named: "sma") else {
            // Handle error when image is not found
            return
        }

        let size = image.size
        let bitmapContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        bitmapContext?.draw(image.cgImage!, in: CGRect(origin: .zero, size: size))

        guard let bitmapData = bitmapContext?.data else {
            // Handle error when accessing bitmap data
            return
        }
        let totalBytes = Int(size.width * size.height * 4)

        let byteArray = Array(UnsafeBufferPointer(start: bitmapData.assumingMemoryBound(to: UInt8.self), count: totalBytes))
        print(byteArray)
        
            //
      
        let width = 12/* width of the bitmap */
        let height = 12 /* height of the bitmap */

        // Create a bitmap context
        let bitmapContext1 = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

        // Set the bitmap data
        bitmapContext1?.data?.copyMemory(from: byteArray, byteCount: byteArray.count)

        // Create a CGImage from the bitmap context
        guard let cgImage = bitmapContext1?.makeImage() else {
            // Handle error when creating CGImage
            return
        }

        // Create a UIImage from the CGImage
        let image2 = UIImage(cgImage: cgImage)
     
        
    }
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
        func covertToGrayScale(with image: UIImage) -> Data? {
          
           let width = Int(image.size.width)
           let height = Int(image.size.height)
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
            print("Main Bitmap : ")
            print(bytes)
            let byteArray: [UInt8] = bytes
          let data = Data(bytes: byteArray)
            print(data)
            
            guard let imagefe = UIImage(data: data) else
            {
                return  data;
            }
            print(data)
           secondImage.image = imagefe
       
        return data;
       }

}
