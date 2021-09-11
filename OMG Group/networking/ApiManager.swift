//
//  ApiManager.swift
//  OMG Group
//
//  Created by Ahmed Allam on 6/13/19.
//  Copyright © 2019 OMG Group. All rights reserved.
//

import Foundation

struct ApiManager {
    let session = URLSession(configuration: .default)
    
    //    private func fetchUrls(completion: @escaping (_ model: OmgUrl?) -> Void){
    //        let urlString = ApiConstants.BASE_URL
    //        guard let url = URL(string: urlString) else {
    //            completion(nil)
    //            return
    //        }
    //
    //        let task = session.dataTask(with: url) { (data, response, error) in
    //            guard error == nil, data != nil else{
    //                print(error!)
    //                completion(nil)
    //                return
    //            }
    //            do{
    //                let omgUrl = try JSONDecoder().decode(OmgUrl.self, from: data!)
    //                completion(omgUrl)
    //
    //            }catch{
    //                print(error)
    //                completion(nil)
    //            }
    //        }
    //        task.resume()
    //    }
    //
    //
    //    func updateUrls(){
    //        fetchUrls { (omgUrls) in
    //            UrlStorage.saveUrls(model: omgUrls)
    //        }
    //    }
    
    
    func getData<T: Codable>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, CustomError>) -> Void){
        let fullUrl = "\(ApiConstants.BASE_URL)\(endpoint.url)"
        guard let url = URL(string: fullUrl) else {
            completion(.failure(.noValidURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil, data != nil else{
                    print(error!)
                    completion(.failure(.somethingWentWrong))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(T.self, from: data!)
                    completion(.success(result))
                    
                }catch{
                    completion(.failure(.cantDecodeObject))
                    print("--------------------")
                    print(String(data: data ?? Data(), encoding: .utf8) ?? "")
                    print("--------------------")
                    print(error)
                    print("--------------------")
                    fatalError("Can't decode")
                }
            }
        }
        task.resume()
    }
    
}

enum CustomError: Error{
    case noValidURL
    case noDataFound
    case somethingWentWrong
    case cantDecodeObject
}
