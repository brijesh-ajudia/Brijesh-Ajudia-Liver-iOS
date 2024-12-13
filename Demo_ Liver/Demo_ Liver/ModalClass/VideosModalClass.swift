//
//  VideosModalClass.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import UIKit

struct VideoModalClass: Decodable {
    let videos : [Videos]?
    
    enum CodingKeys: String, CodingKey {
        
        case videos = "videos"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        videos = try values.decodeIfPresent([Videos].self , forKey: .videos )
        
    }
    
}

struct Videos: Codable {
    let id            : Int?
    let userID        : Int?
    let username      : String?
    let profilePicURL : String?
    let description   : String?
    let topic         : String?
    let viewers       : Int?
    let likes         : Int?
    let video         : String?
    let thumbnail     : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id            = "id"
        case userID        = "userID"
        case username      = "username"
        case profilePicURL = "profilePicURL"
        case description   = "description"
        case topic         = "topic"
        case viewers       = "viewers"
        case likes         = "likes"
        case video         = "video"
        case thumbnail     = "thumbnail"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id            = try values.decodeIfPresent(Int.self    , forKey: .id            )
        userID        = try values.decodeIfPresent(Int.self    , forKey: .userID        )
        username      = try values.decodeIfPresent(String.self , forKey: .username      )
        profilePicURL = try values.decodeIfPresent(String.self , forKey: .profilePicURL )
        description   = try values.decodeIfPresent(String.self , forKey: .description   )
        topic         = try values.decodeIfPresent(String.self , forKey: .topic         )
        viewers       = try values.decodeIfPresent(Int.self    , forKey: .viewers       )
        likes         = try values.decodeIfPresent(Int.self    , forKey: .likes         )
        video         = try values.decodeIfPresent(String.self , forKey: .video         )
        thumbnail     = try values.decodeIfPresent(String.self , forKey: .thumbnail     )

    }
    
}
