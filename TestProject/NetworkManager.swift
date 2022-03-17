//
//  NetworkManager.swift
//  TestProject
//
//  Created by LeandroDiaz on 3/16/22.
//

import Foundation


enum ErrorMessage: String, Error {
    case unableToDecode = "unableToDecode"
    case alreadyCheckedIn = "Your stop is checked"
    case isEmpty = "Nothing to delete"
}

enum NetworkHandler {
    case add, remove
}

enum NetworkManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let milestone = "milestone"
    }
    
    static func updateWith(milestone: LoMAT.StopMilestone, actionType: NetworkHandler, completed: @escaping (ErrorMessage?) -> Void){
        retreiveItems { result in
            
            switch result {
            case .success(let items):
                
                var retreivedItems = items
                
                switch actionType {
                case .add:
                    guard !retreivedItems.contains(where: {$0.id == milestone.id} ) else {
                        completed(.alreadyCheckedIn)
                        return
                    }
                    retreivedItems.append(milestone)
                case .remove:
                    guard !retreivedItems.isEmpty else {
                        completed(.isEmpty)
                        return
                    }
                    retreivedItems.removeAll()
                }
                
                completed(completeChecking(milestones: retreivedItems))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retreiveItems(completed: @escaping (Result<[LoMAT.StopMilestone], ErrorMessage>) -> Void) {
        guard let itemsData = defaults.object(forKey: Keys.milestone) as? Data else {
            completed(.success([]))
            return
        }
        do{
            let decoder = JSONDecoder()
            let items = try decoder.decode([LoMAT.StopMilestone].self, from: itemsData)
            completed(.success(items))
        } catch {
            completed(.failure(.unableToDecode))
        }
    }
    
    static func completeChecking(milestones:  [LoMAT.StopMilestone]) -> ErrorMessage? {
        do{
            let encoder = JSONEncoder()
            let encodedItems = try encoder.encode(milestones)
            defaults.set(encodedItems, forKey: Keys.milestone)
            return nil
        } catch {
            return .unableToDecode
        }
    }
    
}
