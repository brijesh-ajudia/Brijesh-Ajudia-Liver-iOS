//
//  Utils.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import Foundation
import UIKit

struct AppFont {
    enum FontType: String {
        case SF_Black = "SFProText-Black"
        case SF_Bold = "SFProText-Bold"
        case SF_HItalic = "SFProText-HeavyItalic"
        case SF_Light = "SFProText-Light"
        case SF_Medium = "SFProText-Medium"
        case SF_Regular = "SFProText-Regular"
        case SF_Semibold = "SFProText-Semibold"
        case SF_Thin = "SFProText-Thin"
        case SF_UltraLight = "SFProText-Ultralight"
    }
    
    static func font(type: FontType, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size)!
    }
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
let sceneDelegate = windowScene?.delegate as? SceneDelegate

public func screenWidth() -> CGFloat {
    let screenSize = UIScreen.main.bounds
    return screenSize.width
}

public func screenHeight() -> CGFloat {
    let screenSize = UIScreen.main.bounds
    return screenSize.height
}

class DeviceUtility {
    static var deviceHasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return sceneDelegate?.window?.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}

class DictionaryEncoder {
    private let encoder = JSONEncoder()
    
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        set { encoder.dateEncodingStrategy = newValue }
        get { return encoder.dateEncodingStrategy }
    }
    
    var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        set { encoder.dataEncodingStrategy = newValue }
        get { return encoder.dataEncodingStrategy }
    }
    
    var nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy {
        set { encoder.nonConformingFloatEncodingStrategy = newValue }
        get { return encoder.nonConformingFloatEncodingStrategy }
    }
    
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        set { encoder.keyEncodingStrategy = newValue }
        get { return encoder.keyEncodingStrategy }
    }
    
    func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }
    
    func encodeArrayDict<T>(_ value: T) throws -> [[String: Any]] where T : Encodable {
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
    }
}

class DictionaryDecoder {
    private let decoder = JSONDecoder()
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        set { decoder.dateDecodingStrategy = newValue }
        get { return decoder.dateDecodingStrategy }
    }
    
    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        set { decoder.dataDecodingStrategy = newValue }
        get { return decoder.dataDecodingStrategy }
    }
    
    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        set { decoder.nonConformingFloatDecodingStrategy = newValue }
        get { return decoder.nonConformingFloatDecodingStrategy }
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        set { decoder.keyDecodingStrategy = newValue }
        get { return decoder.keyDecodingStrategy }
    }
    
    func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(type, from: data)
    }
    
    func decodeArrayDict<T>(_ type: T.Type, from dictionary: [[String: Any]]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(type, from: data)
    }
}
