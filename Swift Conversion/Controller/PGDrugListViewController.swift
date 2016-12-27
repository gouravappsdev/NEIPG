//
//  PGDrugListViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/30/16.
//  Copyright © 2016 Mobileprogrammingllc. All rights reserved.
//

import UIKit

class PGDrugListViewController: UITableViewController {

   // var drugList = [String]()
    
    var drugList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.handlingNavigationControl()
        self.tableView.separatorColor = UIColor.clear
        self.title = "Consider Reviewing:"
        if (drugList.isEmpty) {
            self.title = "No results"
        }
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let rightButton = UIBarButtonItem(title: "Look Up by Drug", style: .bordered, target: self, action: #selector(self.nextView))
        //self.navigationItem.rightBarButtonItem = rightButton;
        self.setToolbarItems([flex, rightButton], animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Consider Reviewing:"
        if (drugList.isEmpty) {
            self.title = "No results"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //_drugList=nil;
        self.title = nil
        super.viewWillDisappear(animated)
    }
    
    
    private func handlingNavigationControl()
    {
    self.navigationController?.navigationItem.hidesBackButton = true
    // .... Initiate bar buttons
    let btnBack = UIButton()
    let btnImage:UIImage? = UIImage(named:  "back")
    btnBack.frame = CGRect(x: 0, y: 0, width: btnImage!.size.width, height: btnImage!.size.height)
    btnBack.setBackgroundImage(btnImage, for: UIControlState())
    btnBack.addTarget(self, action: #selector(PGDrugListViewController.backAction), for: .touchUpInside)
    
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
        //UIViewController* myViewController = [[UIViewController alloc] init];
        //[[self navigationController] pushViewController:myViewController];
        let newTopViewController = self.storyboard!.instantiateViewController(withIdentifier: "Search")
        self.slidingViewController().topViewController! = newTopViewController
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return drugList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //static NSString *CellIdentifier = @"Cell";
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = drugList[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var indexPath = self.tableView.indexPathForSelectedRow!
        if let controller  = segue.destination as? PGWebViewController
        {
             controller.setGenericDrug(drugList[indexPath.row]) 
        }
    }
}
