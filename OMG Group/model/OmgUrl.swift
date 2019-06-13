//
//  OmgUrl.swift
//  OMG Group
//
//  Created by Ahmed Allam on 6/13/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import Foundation

class OmgUrl: Codable {
    private var tv_url: String?
    private var radio_url: String?
    
    func  radioUrl() -> URL?{
        return URL(string: radio_url ?? "")
    }
    
    func  tvUrl() -> URL?{
        return URL(string: tv_url ?? "")
    }
    
    func  setRadioUrl(url: URL?){
        radio_url = url?.absoluteString
    }
    
    func  setTvUrl(url: URL?){
        tv_url = url?.absoluteString
    }
    
    
    
}
