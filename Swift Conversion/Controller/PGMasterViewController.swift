//
//  PGMasterViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/30/16.
//  Copyright © 2016 Mobileprogrammingllc. All rights reserved.
//

import UIKit

class PGMasterViewController: UITableViewController {
    
    var drugName = ""
    //var detailViewController = PGDetailViewController()
    var objects = [PGCheckList]()
    var itsToDoChecked = [String]()
   
    
    override func awakeFromNib() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: CGFloat(320.0), height: CGFloat(600.0))
        }
        super.awakeFromNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Find Agents For:"
        
        if objects.count == 0 {
            self.title = "No results"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = nil
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        handlingNavigationControl()
        self.tableView.separatorColor = UIColor.clear
        print("self.drugName is \(self.drugName)")
        self.title = "Find Agents For:"
       
        //_objects = [self getMyWines];
        self.objects = PGDataManager.getPresciribeList(self.drugName) 
        if objects.count == 0 {
            self.title = "No results"
        }
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let rightButton = UIBarButtonItem(title: "Look Up by Drug", style: .bordered, target: self, action: #selector(self.nextView))
        //self.navigationItem.rightBarButtonItem = rightButton;
        self.setToolbarItems([flex, rightButton], animated: true)
       // self.detailViewController = self.splitViewController?.viewControllers.last as! PGDetailViewController

    }
    
    private func handlingNavigationControl()
    {
        self.navigationController?.navigationItem.hidesBackButton = true
        // .... Initiate bar buttons
        let btnBack = UIButton()
        let btnImage:UIImage? = UIImage(named:"back")
        btnBack.frame = CGRect(x: 0, y: 0, width: btnImage!.size.width, height: btnImage!.size.height)
        btnBack.setBackgroundImage(btnImage, for: UIControlState())
        btnBack.addTarget(self, action: #selector(PGMasterViewController.backAction), for: .touchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnBack
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func backAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func nextView(_ sender: Any) {
        
        let newTopViewController = self.storyboard!.instantiateViewController(withIdentifier: "Search")
        self.slidingViewController().topViewController! = newTopViewController

    }
    
    @IBAction func backView(_ sender: Any) {
        let newTopViewController = self.storyboard!.instantiateViewController(withIdentifier: "webSID") as! PGWebViewController
        //need to check
       // var vc = (newTopViewController.topViewController! as! PGWebViewController)
        //PGWebViewController *vc = (PGWebViewController *)newTopViewController;
        //vc.drug = self.drugName
        newTopViewController.drugName = self.drugName
        self.slidingViewController().topViewController! = newTopViewController
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.itemName
        cell.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(18))
        return cell

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier! == "showDetail") {
            
            var indexPath = self.tableView.indexPathForSelectedRow!
            let object = objects[indexPath.row]
            let controller = segue.destination as! PGDetailViewController
            controller.detailItem = object
        }
    }
    
    func setMasterItem(_ newString: String) {
        
        self.drugName = newString
    }

}
