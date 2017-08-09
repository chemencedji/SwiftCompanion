//
//  SecondViewController.swift
//  SwiftCompanion
//
//  Created by Igor Chemencedji on 5/13/17.
//  Copyright © 2017 Igor Chemencedji. All rights reserved.
//

import UIKit

struct Skill {
    let name:String?
    let level:String?
    init(name:String, level:String) {
        self.name = name
        self.level = level
    }
}

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    static var skill = [Skill]()
    static var project = [Skill]()
    @IBOutlet weak var scrllView: UIScrollView!
    
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var skillTableView: UITableView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lavel: UILabel!
    @IBOutlet weak var correction: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    var imageBoot = UIImageView()
    var photoUrl: String = "https://cdn.intra.42.fr/users/medium_default.png"
    @IBOutlet weak var wallet: UILabel!
    
    static func addSkill(name:String, level:String)
    {
        SecondViewController.skill.append(Skill(name: name, level: level))
    }
    
    static func addProgress(name:String, level:String)
    {
        SecondViewController.project.append(Skill(name: name, level: level))
    }
    
    func newIcon(){
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: AppDelegate.userImg)!)
            if data == nil {
                let urlName = AppDelegate.userImg
                let alertController = UIAlertController(title: "Error", message: "Cannot acces to \(urlName)", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    self.userPhoto?.image = image
                }
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == self.skillTableView
        {
            return SecondViewController.skill.count
        }
        else
        {
            return SecondViewController.project.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        tableView.backgroundColor = UIColor.black
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 40
        tableView.separatorColor = UIColor.black
        tableView.contentInset = UIEdgeInsets.zero
        
        if tableView == self.skillTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FirstTableViewCell
            cell.name.text = SecondViewController.skill[indexPath.row].name
            cell.level.text = SecondViewController.skill[indexPath.row].level
            return cell
        }
        else
        if tableView == self.projectsTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SecondTableViewCell
            cell.name.text = SecondViewController.project[indexPath.row].name
            cell.level.text = SecondViewController.project[indexPath.row].level
            return cell
        }
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPhoto?.layer.borderWidth = 1
        userPhoto?.layer.masksToBounds = false
        userPhoto?.layer.borderColor = UIColor.black.cgColor
        userPhoto?.layer.cornerRadius = (userPhoto?.frame.height)!/2
        userPhoto?.clipsToBounds = true
        login.text = AppDelegate.userLog
        name.text = AppDelegate.userNam
        phone.text = AppDelegate.userPho
        email.text = AppDelegate.userEma
        wallet.text = "Wallet: \(AppDelegate.userWal)"
        correction.text = "Correction: \(AppDelegate.userCor)"
        lavel.text = "Level: \(AppDelegate.userLvl) - \(AppDelegate.userPrc)%"
        
        progress.progress = AppDelegate.userPro
        self.skillTableView.reloadData()
        self.projectsTableView.reloadData()
        self.newIcon()
        self.scrllView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
