//
//  HelperFunction.swift
//  iOS
//
//  Created byiOS on 23/05/20
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation


class HelperFunction {
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static var helper = HelperFunction()
    public func storeInUserDefaultForKey(name:String,val:String){
        UserDefaults.standard.set(val, forKey: name)
        UserDefaults.standard.synchronize()
    }
    public func FetchFromUserDefault(name:String)->String{
        if(UserDefaults.standard.object(forKey: name)==nil){
            return ""
        }else{
            return (UserDefaults.standard.object(forKey: name) as? String)!
        }
        
    }
    
    public func storeIntUserDefaultForKey(name:String,val:Int){
        UserDefaults.standard.set(val, forKey: name)
        UserDefaults.standard.synchronize()
    }
    public func FetchIntFromUserDefault(name:String)->Int{
        if(UserDefaults.standard.object(forKey: name)==nil){
                   return 0
               }else{
                   return (UserDefaults.standard.object(forKey: name) as? Int)!
               }
        //return (UserDefaults.standard.object(forKey: name) as? Int)!
    }
    public func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    public func isLogin()->Bool{
        var login = false
        if(UserDefaults.standard.object(forKey: "IsLogin")==nil){
            login = false
        }else{
            login = (UserDefaults.standard.object(forKey: "IsLogin") as? Bool)!
        }
        
        return login
    }
    public func setLogin(){
        UserDefaults.standard.set(true, forKey: "IsLogin")
        UserDefaults.standard.synchronize()
    }
    public func setLogout(){
        UserDefaults.standard.set(false, forKey: "IsLogin")
        UserDefaults.standard.synchronize()
    }
    public func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return  true//passwordTest.evaluate(with: password)
    }
    public func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
