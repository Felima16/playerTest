//
//  iTunesAPI.swift
//  PlayerTest
//
//  Created by Fernanda de Lima on 18/01/2018.
//  Copyright © 2018 Empresinha. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import AlamofireImage
import Alamofire
import ObjectMapper


class iTunnesAPI{
    
    //cria o get pegando as infomaçoes mapeando qualquer tipo de classe mappable
    static func get <T: Any>
        (_ type: T.Type,
         url: String,
         finish:@escaping () -> Void,
         success:@escaping (_ item: T) -> Void,
         fail:@escaping (_ error: Error,_ code:Int?) -> Void) -> Void where T:Mappable {
        Alamofire.request(url).responseObject { (response: DataResponse<T>) in
            print("GET ------ \(url) with status code \(response.response?.statusCode ?? 0)")
            if response.response?.statusCode == 404{
                finish()
            }else{
                switch response.result {
                case .success(let item):
                    print("Response from GET ---- \(String(describing: response.result.value))")
                    success(item)
                case .failure(let error):
                    print("ERROR GET ---- ", error)
                    fail(error, (response.response?.statusCode)!)
                }
            }
        }
    }
    
    //get de imagens
    static func getImage(url: String,
                         success: @escaping (_ img: Image) -> Void,
                         fail:@escaping (_ error: Error) ->Void){
        
        Alamofire.request(url).responseImage { response in
            switch response.result{
            case .success:
//                print("Response from IMAGE ---- \(response.result.value)")
                if let img = response.result.value{
                    success(img)
                }
            case .failure(let error):
                print("ERROR POST ---- ", error)
                fail(error)
            }
        }
    }
    
    /**
     funcao para fazer download atraves do endereco url
     em caso de sucesso, eh retornado o endereco aonde foi salvo temporariamente o arquivo
     em caso de erro, retorna o erro ocorrido
     **/
    static func downloadFile(url: String, name: String,
                             success: @escaping (_ path:URL) -> Void,
                             fail:@escaping (_ error: Error?, _ code:Int?) ->Void){
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
        
        Alamofire.download(url, to: destination).downloadProgress { (progress) in
            print(progress.fractionCompleted)
            }.response { (response) in
                
                if response.response?.statusCode == 200 {
                    print("Response saved in path ---- \(response.destinationURL!)")
                    success((response.destinationURL)!)
                }else if let error = response.error{
                    print("\n ERROR DOWNLOAD ---- \(error)")
                    fail(error,response.response?.statusCode)
                }else{
                    print("DOWNLOAD ------ \(url) with status code \(response.response?.statusCode ?? 0)")
                    fail(nil, response.response?.statusCode)
                }
        }
    }
}
