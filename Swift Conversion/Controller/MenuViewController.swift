//
//  MenuViewController.
//  NEIPG
//
//  Created by Gourav Sharma on 11/30/16.
//  Copyright © 2016 Mobileprogrammingllc. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var names = [String : AnyObject]()
    var menu = [AnyObject]()
    var menuKey = [AnyObject]()
    @IBOutlet var mainTableView : UITableView?
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.names = PGDataManager.getContentHeader() 
        self.menuKey =  self.names["key"] as! [AnyObject]
        self.menu = self.names["value"] as! [AnyObject]
        self.menuKey.append(self.menuKey[0])
        self.menu.append("Top" as AnyObject)
        self.slidingViewController().anchorRightRevealAmount = 200.0
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return self.menuKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell = tableView.dequeueReusableCell(withIdentifier: "ListIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ListIdentifier")
        }
        cell?.backgroundColor = UIColor.clear
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.textLabel!.text  = "\(self.menu[indexPath.row])"
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(14))
        return cell!
    }


     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let identifier = "\(self.menuKey[indexPath.row])"
        let navController = (self.slidingViewController().topViewController! as! UINavigationController)
        let vc = (navController.topViewController! as! PGWebViewController)
       vc.setMenuItem(identifier)
       self.slidingViewController().resetTopView(animated: true)
    }

}
