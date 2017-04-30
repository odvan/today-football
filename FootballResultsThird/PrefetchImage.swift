//
//  Prefetch.swift
//  FootballResultsThird
//
//  Created by Artur Kablak on 23/03/17.
//  Copyright © 2017 Artur Kablak. All rights reserved.
//

import UIKit

// MARK: Class for teams images async background downloading

typealias ImageLoadOperationCompletionHandlerType = ((UIImage) -> ())?

class ImageLoadOperation: Operation {
    
    var url: String
    var completionHandler: ImageLoadOperationCompletionHandlerType
    var image: UIImage?
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        if self.isCancelled {
            print("cancelled")
            return
        }
        
        UIImage.downloadImageFromUrl(url) { [weak self] (image) in
            
            guard let strongSelf = self else {
                return
            }
            guard !strongSelf.isCancelled,
                let image = image else {
                    print("cancelled: second time, url:\(strongSelf.url)")
                    return
            }
            strongSelf.image = image
            strongSelf.completionHandler?(image)
        }

    }

}
