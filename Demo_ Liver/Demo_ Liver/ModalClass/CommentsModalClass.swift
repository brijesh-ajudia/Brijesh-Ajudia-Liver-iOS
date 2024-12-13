//
//  CommentsModalClass.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import Foundation
import UIKit

class CommentsModalClass: Codable {
    var comments : [Comments]?
    
    enum CodingKeys: String, CodingKey {
        
        case comments = "comments"
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        comments = try values.decodeIfPresent([Comments].self , forKey: .comments )
        
    }
    
}

struct Comments: Codable {
    
    let id       : Int?
    let username : String?
    let picURL   : String?
    let comment  : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id       = "id"
        case username = "username"
        case picURL   = "picURL"
        case comment  = "comment"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id       = try values.decodeIfPresent(Int.self    , forKey: .id       )
        username = try values.decodeIfPresent(String.self , forKey: .username )
        picURL   = try values.decodeIfPresent(String.self , forKey: .picURL   )
        comment  = try values.decodeIfPresent(String.self , forKey: .comment  )
        
    }
    
}
