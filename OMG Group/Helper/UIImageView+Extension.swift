//
//  UIImageView+Extension.swift
//  OMG Group
//
//  Created by Ahmed Allam on 11/09/2021.
//  Copyright © 2021 OMG Group. All rights reserved.
//
import UIKit
import Kingfisher

extension UIImageView{
    func setImageKF(path: String?, andPlaceholder placeholder:UIImage? = nil, completion: (() -> ())? = nil ){
        let fullURL = "\(ApiConstants.STORAGE_BASE_URL)\(path ?? "")"
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        self.kf.setImage(
            with: URL(string: fullURL),
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ], completionHandler:
                {
                    result in
                    switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                    }
                })
    }
    
    
}
