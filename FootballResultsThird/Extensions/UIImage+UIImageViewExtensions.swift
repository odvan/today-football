//
//  UIIMageExtension.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 23/03/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

// MARK: Method for background async image loading

extension UIImage {
    
    static func downloadImageFromUrl(_ url: String, completionHandler: @escaping (UIImage?) -> Void) {
        
        guard let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded)
            else {
                completionHandler(nil)
                return
        }
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            
            guard let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else {
                    completionHandler(nil)
                    return
            }
        
//        guard let imageData = NSData(contentsOf: url) else { return }
        
            if let image: SVGKImage = SVGKImage(data: data) {
                
                let img = image.uiImage
                completionHandler(img)
                
            } else {
                
                let image = UIImage(data: data)
                    completionHandler(image)
                
            }
        })
        task.resume()
    }
    
    // Second method just for experimentation
    
    static func downloadImageFromUrlSecond(_ url: String, completionHandler: @escaping (UIImage?) -> Void) {
        
        guard let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded)
            else {
                completionHandler(nil)
                return
        }
        
        // DispatchQueue.global(qos: .userInitiated).async {
        guard let imageData = NSData(contentsOf: url) else { return }
        
        if let image: SVGKImage = SVGKImage(data: imageData as Data!) {
            
            let img = image.uiImage
            completionHandler(img)
            
        } else {
            
            let image = UIImage(data: imageData as Data)
            completionHandler(image)
            
            //}
        }
    }
}

// MARK: Put downloaded team image to the table cell in the main queue

extension UIImageView {
    
    func setTeamLogo(_ image: UIImage?) {
        
        if let image = image {
            
            DispatchQueue.main.async() { [weak self]  in
                guard let strongSelf = self else { return }
                
                strongSelf.image = image
            }
            
        } else {
            
            DispatchQueue.main.async() { [weak self]  in
                guard let strongSelf = self else { return }
                
                strongSelf.image = #imageLiteral(resourceName: "placeHolderLogo")
            }
        }
    }
    
}


