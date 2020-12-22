//
//  backup.swift
//  Journal Plus
//
//  Created by Jacob Hanna on 06/07/2018.
//  Copyright © 2018 Jacob Hanna. All rights reserved.
//

import UIKit

//backup keys


//BackUp function
class BackUp{
    var code = String()
    var defaults = UserDefaults.init(suiteName: "group.Jacob.Hanna.Journal")!
    
    //Use when dont want to restore everything
    init (_ code:String){
        self.code = code
    }
    
    func printAll(){
        print(defaults.dictionaryRepresentation())
    }
    
    //if a value is available for key
    var isAvailable : Bool{
        return(defaults.value(forKey: code) != nil)
    }
    
    //restore value for the key
    func restoreValue(){
        defaults.removeObject(forKey: code)
    }
    
    //restore all values from the app
    func restoreEverything(){
        if(code == "18111998"){
            defaults.dictionaryRepresentation().keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    func set<T> (_ value : T){

        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            defaults.set(data, forKey: code)
            defaults.synchronize()
        }
        catch{
            return
        }
        
    }
    
    func get<T>() -> T?{
        if let data = defaults.value(forKey: code) as? Data{
            do{
                if let titles = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T{
                    return titles
                }else{
                    return nil
                    
                }
            }
            catch{
                return nil
            }
            
        }else{
            return nil
        }
    }
    
    func set<T : Encodable> (_ value : T){
        do {
            let data = try JSONEncoder().encode(value)
            defaults.set(data, forKey: code)
            defaults.synchronize()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    func get<T : Decodable>() -> T?{
        if let data = defaults.value(forKey: code) as? Data{
            do{
                let titles = try JSONDecoder().decode(T.self, from: data)
                return titles
            }
            catch{
                return nil
            }
        }else{
            return nil
        }
    }
}
