//
//  ITNetworkManager.swift
//  itunesFetch
//
//  Created by Arbi on 9/15/17.
//  Copyright © 2017 arbiapps. All rights reserved.
//

import UIKit


protocol ITNetworkManagerProtocol:class{
    
    func successWithData(data:[ITMusicData])
    
}

class ITNetworkManager: NSObject {

     let endPointURL = "https://itunes.apple.com/search"
     var fullURL = ""
     var listOfMusicData:[ITMusicData] = []
     weak var ITNetworkManagerDelegate: ITNetworkManagerProtocol?
    
    func buildURL(termValue:String, mediaTypeValue:String)->URL?{
        
        guard let fullURL = "\(endPointURL)?term=\(termValue)&media=\(mediaTypeValue)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) else{
            print("fullURLString is NULL")
            return nil
        }
        guard let url = URL(string:fullURL)else{
            print("url is NULL")
            return nil
        }
        return url
    }
    
    
    func serializeData(data:Data?)->[String:Any]?{
        
        guard let responseData = data else{
            print("responseData is NULL")
            return nil
        }
        do{
            
            guard let serializedData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] else{
                
                print("serialized Data is null")
                return nil
            }
            return serializedData
            
        }catch{
            print("error occured serializing the data")
        }
        return nil
    }
    
    func fetchItunesData(term:String, mediaType:String){
        
        guard let itunesURL =  buildURL(termValue: term, mediaTypeValue: mediaType) else{
            return
        }
        
        DispatchQueue.global().async {[unowned self] in
        
        URLSession.shared.dataTask(with: itunesURL) { (data,resp, error) in
            print(resp ?? "error")
            guard let serialData = self.serializeData(data: data) else{
                print("serialized data is invalid")
                return
            }
            self.mapDataToClass(data: serialData)
            DispatchQueue.main.async {[unowned self] in
            if self.listOfMusicData.count > 0 {
                
            self.ITNetworkManagerDelegate?.successWithData(data: self.listOfMusicData)
            }
            else{
                print("count of MusicData is 0")
            }
          }
        }.resume()
        }
    }
    
    func fetchImageForURL(urlString:String, success:@escaping (_ image:UIImage)->Void){
        
        guard let url = URL(string:urlString) else{
            print("urlString is NULL")
            return 
        }
        
        
        DispatchQueue.global().sync {
            URLSession.shared.dataTask(with: url) { data, resp, err in
                
                guard let data = data else{
                    print("imageData was invalid")
                    return
                }
                DispatchQueue.main.sync {
                    
                    guard let image = UIImage(data: data) else{
                        print("image was invalid")
    
                        return
                    }
               
                    success(image)
                  }
                
                }.resume()

        }
        
    }
    func mapDataToClass(data:[String:Any]){
        
        var musicData = ITMusicData()
        
        if let resultArray = data["results"] as? [[NSString:Any]] {
            
            for dataDict in resultArray{
                
                musicData.wrapperType =  dataDict["wrapperType"] as? String
                musicData.kind = dataDict["kind"] as?String
                musicData.artistId = dataDict["artistId"] as? Int
                musicData.collectionId = dataDict["collectionId"] as? Int
                musicData.trackId = dataDict["trackId"] as? Int
                musicData.artistName = dataDict["artistName"] as? String
                musicData.collectionName = dataDict["collectionName"] as? String
                musicData.trackName = dataDict["trackName"] as? String
                musicData.collectionCensoredName = dataDict["collectionCensoredName"] as? String
                musicData.trackCensoredName = dataDict["trackCensoredName"] as? String
                musicData.artistViewUrl = dataDict["artistViewUrl"] as? String
                musicData.collectionViewUrl = dataDict["collectionViewUrl"] as? String
                musicData.trackViewUrl = dataDict["trackViewUrl"] as? String
                musicData.previewUrl = dataDict["previewUrl"] as? String
                musicData.artworkUrl30 = dataDict["artworkUrl30"] as? String
                musicData.artworkUrl60 = dataDict["artworkUrl60"] as? String
                musicData.artworkUrl100 = dataDict["artworkUrl100"] as? String
                musicData.collectionPrice = dataDict["collectionPrice"] as? Double
                musicData.trackPrice = dataDict["trackPrice"] as? Double
                musicData.releaseDate = dataDict["releaseDate"] as? String
                musicData.collectionExplicitness = dataDict["collectionExplicitness"] as? String
                musicData.trackExplicitness = dataDict["trackExplicitness"] as? String
                musicData.discCount = dataDict["discCount "] as? Int
                musicData.discNumber = dataDict["discNumber"] as? Int
                musicData.trackCount = dataDict["trackCount"] as? Int
                musicData.trackNumber = dataDict["trackNumber"] as? Int
                musicData.trackTimeMillis = dataDict["trackTimeMillis"] as? Int
                musicData.country = dataDict["country"] as? String
                musicData.currency = dataDict["currency"] as? String
                musicData.primaryGenreName = dataDict["primaryGenreName"] as? String
                musicData.isStreamable = dataDict["isStreamable"] as? String
                listOfMusicData.append(musicData)
            }
        }
    }
}
