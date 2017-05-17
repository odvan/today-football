//
//  CustomImageView.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 18/05/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

let imgCache = NSCache<AnyObject, ImageLoadOperation>()
let imageLoadQueue = OperationQueue()

class CustomImageView: UIImageView {
    
    var checkUrl: String?
    
    func updateLogo(link: String?) {
        
        checkUrl = link
        
        if let imageLoadOperation = imgCache.object(forKey: link as AnyObject),
        let imageLogo = imageLoadOperation.image {
            
            print("extracting image from cache")
            image = imageLogo
            
        } else {
            
            image = #imageLiteral(resourceName: "placeHolderLogo")
            let imageLoadOperation = ImageLoadOperation(url: link!)
            
            imageLoadOperation.completionHandler = { [weak self] (imageLogo) in
                guard let strongSelf = self else { return }
                
                if strongSelf.checkUrl == link {
                    strongSelf.setTeamLogo(imageLogo)
                } else {
                    print("image ignored because of wrong URL")
                }
            }
            imageLoadQueue.addOperation(imageLoadOperation)
            imgCache.setObject(imageLoadOperation, forKey: link as AnyObject)
            
        }
    }
    
}
