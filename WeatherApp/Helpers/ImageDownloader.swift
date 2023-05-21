//
//  ImageDownloader.swift
//  WeatherApp
//
//  Created by Harshavardhan Tadiparthi on 20/05/23.
//

import Foundation

import UIKit
class ImageDownloader {
    let imageCache = NSCache<AnyObject, AnyObject>()

     func downloadImage(_ urlString: String, completion: @escaping ((UIImage?) -> ())) {
       guard let url = URL(string: urlString) else {
          completion(nil)
          return
      }
         // retrieves image if already available in cache
         if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
             completion(imageFromCache)
             return
         }
      URLSession.shared.dataTask(with: url) { (data, response,error) in
         if let error = error {
            print("error in downloading image: \(error)")
            completion(nil)
            return
         }
         guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
            completion(nil)
            return
         }
         if let data = data, let image = UIImage(data: data) {
             self.imageCache.setObject(image, forKey: url as AnyObject)
            completion(image)
            return
         }
         completion(nil)
      }.resume()
   }
}
