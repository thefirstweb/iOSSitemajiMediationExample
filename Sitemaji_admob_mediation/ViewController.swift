//
//  ViewController.swift
//  Sitemaji_admob_mediation
//
//  Created by Alex on 2021/1/15.
//

import UIKit

extension NSObject {
    class func fromClassName(className : String) -> NSObject {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
        
        if let toClass: UIViewController.Type = NSClassFromString(className) as? UIViewController.Type {
            let toController: UIViewController = toClass.init()
            return toController
        }
        
        return NSObject.init()
    }
}

class ViewController: UIViewController {
    private var settingList = Array<Array<Dictionary<String, String>>>()
    let settingListTableView:UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Sitemaji Demo"
        
        createUI()
        getData()
        cellRegister()
    }
    
    func createUI() {
        let settingListTableViewOriginY:CGFloat = 0
        let settingListTableViewHeight:CGFloat = self.view.frame.size.height
        settingListTableView.frame = CGRect.init(x: 0, y: settingListTableViewOriginY, width: self.view.frame.size.width, height: settingListTableViewHeight)
        settingListTableView.separatorStyle = .singleLine
        settingListTableView.showsVerticalScrollIndicator = false
        settingListTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        settingListTableView.delegate = self
        settingListTableView.dataSource = self
        
        self.view.addSubview(settingListTableView)
    }
    
    func cellRegister() {
        settingListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CodeCell")
    }
}

extension ViewController {
    //MARK: - Get Data
    private func getData(isRefreshData:Bool = false){
        self.settingList.removeAll()
        
        var section0Array:Array<Any> = []
        let bannerDic = self.makeItemWithGAType(title: "橫幅廣告", action: "controller", link: "BannerViewController")
        section0Array.append(bannerDic)
        
        var section1Array:Array<Any> = []
        let InterstitialDic = self.makeItemWithGAType(title: "蓋版廣告", action: "controller", link: "InterstitialViewController")
        section1Array.append(InterstitialDic)
        
        var section2Array:Array<Any> = []
        let RewardADDic = self.makeItemWithGAType(title: "獎勵式廣告", action: "controller", link: "RewardADViewController")
        section2Array.append(RewardADDic)
        
        self.settingList.append(section0Array as! [Dictionary<String, String>])
        self.settingList.append(section1Array as! [Dictionary<String, String>])
        self.settingList.append(section2Array as! [Dictionary<String, String>])
    }
    
    private func makeItemWithGAType(title:String = "",action:String = "",link:String = "",type:String = "",isShowAccessory:String = "true") -> Dictionary<String, String>{
        var tempDic:[String:String] = [:]
        tempDic["title"] = title
        tempDic["action"] = action
        tempDic["link"] = link
        tempDic["type"] = type
        tempDic["isShowAccessory"] = isShowAccessory

        return tempDic
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingList.count
    }
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.settingList[section] as AnyObject).count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemDic = self.settingList[indexPath.section][indexPath.row] as Dictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeCell", for: indexPath as IndexPath) as! UITableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        
        cell.textLabel?.text = itemDic["title"]
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.text = ""
        
        if itemDic["isShowAccessory"] == "true" {
            cell.accessoryType = .disclosureIndicator
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controllerName = self.settingList[indexPath.section][indexPath.row]["link"] {
            if let vc = NSObject.fromClassName(className: controllerName) as? UIViewController {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44.0
    }
}
