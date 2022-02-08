//
//  Utils.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIColor
import Firebase

enum ShadowType {
    case shadowIsAbove
    case shadowIsBelow
}

struct Utils {
    
    static func addShadow(type: ShadowType, layer: CALayer, opacity: Float? = nil) {
        layer.shadowColor = Palette.black.color.cgColor
        
        switch type {
        case .shadowIsAbove:
            layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        case .shadowIsBelow:
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        }
        
        layer.shadowRadius = 6.0
        if let opacity = opacity {
            layer.shadowOpacity = opacity
            return
        }
        layer.shadowOpacity = 0.07
    }
    
    static func handleDate(unixDate: Int) -> String {
        let baseDate = Date().timeIntervalSince1970
        let amountOfHoursSinceStoryHadPosted = (baseDate - Double(unixDate / 1000000)) / 60
        if amountOfHoursSinceStoryHadPosted < 60 {
            return String(Int(amountOfHoursSinceStoryHadPosted.rounded(.down))) + "мин."
        }
        return String(Int((amountOfHoursSinceStoryHadPosted / 60).rounded(.down))) + "ч."
    }
    
    static func addCredentialsToFireBase() {
        let credentialsString = "" /// add credentialsString to send it to the Firebase, the separator should be ":"
        
        if credentialsString.isEmpty { return }
        
        let dataBase = Database.database().reference()
        
        var finalDict = [String: String]()
        
        credentialsString
            .components(separatedBy: ",")
            .map { $0.components(separatedBy: ":") }
            .map { [$0[0] : $0[1]] }
            .forEach {
                guard let key = $0.keys.first,
                      let value = $0.values.first else { return }
                finalDict[key] = value
            }
        
        for pair in finalDict {
            let key = Utils.replaceCharacter(value: pair.key, of: ".", with: "?")
            dataBase.child(key).setValue(pair.value)
        }
    }
    
    static func replaceCharacter<T: StringProtocol>(value: String, of: T, with: T) -> String {
        return value.replacingOccurrences(of: of, with: with)
    }
}
