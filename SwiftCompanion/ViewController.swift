//
//  ViewController.swift
//  SwiftCompanion
//
//  Created by Igor Chemencedji on 5/9/17.
//  Copyright © 2017 Igor Chemencedji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    let UID = "9e78320c4fb1d01a51798719d134c35af7733a1dea542fcd59ac8894479c09ce"
    let SECRET = "3222ea9bd2d72f8941f5e124bd94bea1842fabf03d233db8eb4f6a4bfa520da7"
    var loginSuccess = true
    var tokenGlobal: String = ""
    var imagePath: String = ""
    
    
    @IBOutlet weak var buttonStyle: UIButton!
    @IBOutlet weak var nameInserted: UITextField!
    
    @IBAction func findStudent(_ sender: UIButton) {
        loginSuccess = true
        if (nameInserted.text?.isEmpty)! {
            let alertView = UIAlertController(title: "Error", message: "Empty string was detected.\nPlease insert intra.42.fr login", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            self.loginSuccess = false
            performSegue(withIdentifier: "login", sender: nil)
        }
        else {
            self.queryRequest()
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if loginSuccess == false {
            return false
        }
        else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStyle.layer.cornerRadius = 20
        
        let BEARER = ((UID + ":" + SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER, forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(SECRET)".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if nil != error{
                print(error.debugDescription)
            }
            else if let d = data {
                do {
                    //print("\(d.description)")
                    let dic: Dictionary = try JSONSerialization.jsonObject(with: d, options: []) as! [String:Any]
                    print("\(dic.description)")
                    self.tokenGlobal = (dic["access_token"] as? String)!
                }
                catch (let err){
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    func queryRequest(){
        let userinfo = "https://api.intra.42.fr/v2/users/" + nameInserted.text!
        let info = URL(string: userinfo.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var url = URLRequest(url: info!)
        url.httpMethod = "GET"
        url.setValue("Bearer \(self.tokenGlobal)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            }
            else
            {
                DispatchQueue.main.async {
                    do {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                        if dic["image_url"] != nil {
                        print("\(dic.description)")
                        self.imagePath = dic["image_url"]! as! String
                        let userName = dic["displayname"]! as! String
                        let userLogin = dic["login"]! as! String
                        let userEmail = dic["email"]! as! String
                        let userWallet = dic["wallet"]! as! Int
                        let userCorrect = dic["correction_point"]! as! Int
                        let userP: String? = dic["phone"] as? String
                        let dic2 = dic["cursus_users"] as! [NSDictionary]
                        var dr = NSDictionary()
                        for d in dic2
                        {
                            if d.value(forKey: "cursus_id") as! Int == 1
                            {
                                dr = d
                            }
                        }
                        let sk = dr.value(forKey: "skills") as! [NSDictionary]
                        for s in sk
                        {
                            SecondViewController.addSkill(name: s.value(forKey: "name") as! String, level: String(describing: s.value(forKey: "level")!))
                        }
                        let dic3 = dic["projects_users"] as! [NSDictionary]
                        for d in dic3
                        {
                            let proj = d.value(forKey: "project") as! NSDictionary
                            let final = d.value(forKey: "final_mark")
                            let namePr = proj.value(forKey: "name")
                            SecondViewController.addProgress(name: String(describing: namePr!), level: String(describing: final!))
                        }
//                        print(sk)
                        AppDelegate.userLvl = String(describing: dr.value(forKey: "level")! as! Int)
                        let forProcent: Int = Int((dr.value(forKey: "level")! as! Float).multiplied(by: 100).truncatingRemainder(dividingBy: 100))
                        AppDelegate.userPrc = String(describing: forProcent)
                        AppDelegate.userPro = Float(forProcent) / 100
                        AppDelegate.userNam = userName
                        AppDelegate.userLog = userLogin
                        AppDelegate.userEma = userEmail
                        AppDelegate.userWal = userWallet
                        AppDelegate.userCor = userCorrect
                        if userP != nil {
                            let userPhone = dic["phone"]! as! String
                            AppDelegate.userPho = userPhone
                        }
                        else {
                            AppDelegate.userPho = "Sorry no phone"
                        }
                        if self.imagePath.contains("https://cdn.intra.42.fr/images/default.png") == false {
                            AppDelegate.userImg = self.imagePath
                        }
                        else
                        {
                            AppDelegate.userImg =  "https://cdn.intra.42.fr/users/medium_default.png"
                        }
                        self.performSegue(withIdentifier: "showSecond", sender: self)
                        }
                        else
                        {
                            let alertView = UIAlertController(title: "Error", message: "Insert full name", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            })
                            alertView.addAction(action)
                            self.present(alertView, animated: true, completion: nil)
                        }
                    }
                    catch let err
                    {
                        print(err)
                    }
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

