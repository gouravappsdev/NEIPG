//
//  PGDetailTableViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/28/16.
//  Copyright © 2016 Yaogeng Cheng. All rights reserved.
//

import UIKit

class PGDetailViewController: UITableViewController {
    
    private var objects = Dictionary<String, Array<PGCheckList>>()
    private var names =  Dictionary<String, Array<String>>()
    private var keys = [String]()
    var detailItem = PGCheckList()
   
    func configureView()
    {
        let args = self.detailItem
        
        //get the list of consideration
        if let drugName = args.drugName
        {
             objects = PGDataManager.getConsiderationList(drugName)
             names = PGDataManager.getConsiderationKeys(drugName)
             keys = [String](names.keys)
        }
        
        if objects.isEmpty
        {
            self.title = "No results"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handlingNavigationControl()
        self.configureView()
        self.title = "Find Agents That:"
        if self.objects.count == 0 {
            self.title = "No results"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "Find Agents That:"
        if self.objects.count == 0 {
            self.title = "No results"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.title = nil
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func handlingNavigationControl()
    {
        self.navigationController?.navigationItem.hidesBackButton = true
        // .... Initiate bar buttons
        let btnBack = UIButton()
        let btnImage:UIImage? = UIImage(named:  "back")
        btnBack.frame = CGRect(x: 0, y: 0, width: btnImage!.size.width, height: btnImage!.size.height)
        btnBack.setBackgroundImage(btnImage, for: UIControlState())
        btnBack.addTarget(self, action: #selector(PGDetailViewController.backAction), for: .touchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnBack
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func backAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let key = keys[section]
        let object = objects[key]
        return (object?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier:cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier:cellID)
        }
    
        let key = keys[indexPath.section]
        if let objectsArr = objects[key]
        {
            let item = objectsArr[indexPath.row]
            cell?.textLabel!.text = item.itemName
            //cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell?.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(18))
            if item.checked! {
                cell?.accessoryType = .checkmark
            }
            else {
                cell?.accessoryType = .none
            }
        }
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let key = keys[indexPath.section]
       
        
        if let objectVal = objects[key]
        {
            let item = objectVal[indexPath.row]
            item.checked = !item.checked!
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var keyNames = (names[keys[section]])
        // Create label with section title
        let label = UILabel()
        label.frame = CGRect(x: CGFloat(34), y: CGFloat(0), width: CGFloat(284), height: CGFloat(30))
        label.font = UIFont.boldSystemFont(ofSize: CGFloat(18))
        let view = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(320), height: CGFloat(100)))
        view.backgroundColor = UIColor.colorWithHexString("53739b")
        if let sectionImage = keyNames?[1]
        {
            let myImage = UIImage(named: sectionImage)
            let imageView = UIImageView(image: myImage)
            imageView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(30), height: CGFloat(30))
            view.addSubview(imageView)
        }
        
        if let sectionTitle = keyNames?[0]
        {
            label.text = sectionTitle
        }
        
        view.addSubview(label)
        return view
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var isChecked = false
    
            let sql = "\("SELECT GenericName FROM DrugConsiderations where CategoryCode='PRESCRIBE' and ConsiderationsID=")\(Int(detailItem.itemId!))"
            let sql1 = " and GenericName not in (SELECT GenericName FROM DrugConsiderations where "
            //NSString stringWithFormat:@"%i ",i]
            var theString = String()
            theString += sql
            
            for key: String in keys {
                
                let arr = objects[key]
                for object in arr! {
                    
                    let item = object
                    if item.checked! {
                        if !isChecked {
                            theString += sql1
                            isChecked = !isChecked
                        }
                        else {
                            theString += " or "
                        }
                        if item.rankId! > 0 {
                            theString += "\("(CategoryCode='")\(key)\("' and ConsiderationsID=")\(Int(item.itemId!))\(" and RankID>=")\(Int(item.rankId!))\(")")"
                        }
                        else {
                            theString += "\("(CategoryCode='")\(key)\("' and ConsiderationsID=")\(Int(item.itemId!))\(")")"
                        }
                    }
                }
            }
            
            if isChecked {
                
                theString += ") order by GenericName"
            }
            else {
                theString += " order by GenericName"
            }
            print("sql: \(theString)")
            
          // segue.destination.setdru
        
        if let controller = segue.destination as? PGDrugListViewController
        {
             controller.drugList =  PGDataManager.getAlternateDrugList(theString)
        }
       }
}
