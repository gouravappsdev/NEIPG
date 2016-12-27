
//
//  AutoCompleteTextFieldViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/21/16.
//  Copyright © 2016 Yaogeng Cheng. All rights reserved.
//

import UIKit

class AutoCompleteTextFieldViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var autoCompleteArray = [String]()
    private var elementArray = [String]()
    private var lowerCaseElementArray = [String]()
    @IBOutlet var txtField: UITextField!
    @IBOutlet var autoCompleteTableView: UITableView!
    @IBOutlet var segmentControl: UISegmentedControl!
    private var keyboardHeight: CGFloat = 0.0
    private var barHeightP: Float = 0.0
    private var barHeightL: Float = 0.0
    private var iconImageView: UIImageView!
   
   //var shortCutItemDrug:String?
    
    var shortCutItemDrug: String? {
        
        get {
            return self.shortCutItemDrug
        }
        set {
            self.shortCutItemDrug = newValue
        }
    }

    func finishedSearching() {
        
        txtField.resignFirstResponder()
        self.autoCompleteTableView.frame.size.height = self.autoCompleteTableView.frame.size.height+keyboardHeight
        keyboardHeight = 0
    }
    
    
    // MARK: -
    // MARK: - View Life Cycle Methods
    // MARK: -
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "Look Up"
        txtField.text = ""
        autoCompleteArray.removeAll()
        self.autoCompleteTableView.reloadData()
        iconImageView.isHidden = false
   }

    override func viewWillDisappear(_ animated: Bool) {
        self.title = nil
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIDeviceOrientationDidChange , object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Register notification when the keyboard will be show
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
       
        
       //get data from local database
        elementArray = PGDataManager.getDrugList()

       
        let m_icon1 = UIImage(named: "nei_logo")!
        iconImageView = UIImageView(image: m_icon1)
        //imageView.frame = CGRectMake(0,110,261, 40);
        var frame1 = iconImageView.frame
        frame1.origin.x = self.view.bounds.midX - iconImageView.bounds.midX
        if let savedValue = UserDefaults.standard.string(forKey: "NEIGroupName")  {
           
            let icon_path = Bundle.main.path(forResource: savedValue, ofType: "gif")!
            let m_icon = UIImage(contentsOfFile: icon_path)!
            let imageView = UIImageView(image: m_icon)
            var frame = imageView.frame
            frame.origin.x = self.view.bounds.midX - imageView.bounds.midX
            frame.origin.y = 210.0 - m_icon.size.height - 10
            imageView.frame = frame
            imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            self.view.addSubview(imageView)
            frame1.origin.y = 250
        }
        else {
            frame1.origin.y = 210
        }
        
        iconImageView.frame = frame1
        iconImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        self.view.addSubview(iconImageView)
        iconImageView.isHidden = false
     
       
        //self.navigationItem.leftBarButtonItem=newBackButton;
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let rightButton = UIBarButtonItem(title: "Disclaimer", style: .bordered, target: self, action: #selector(self.openDisclaimer))
        self.setToolbarItems([flex, rightButton], animated: true)
        
        //segment color
        
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.colorWithHexString("1656FF"),
            NSFontAttributeName: UIFont(name: "Helvetica", size: 13)!
        ]
        
        segmentControl.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], for: UIControlState.selected)
    }
    
    
    // MARK: -
    // MARK: - Button Action Methods
    // MARK: -
    
    @IBAction func openDisclaimer(_ sender: Any) {
        let disclaimerController = self.storyboard!.instantiateViewController(withIdentifier: "viewdisclaimer")
        self.present(disclaimerController, animated: true, completion: { _ in })
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl)
    {
        //remove data
       elementArray.removeAll()
       autoCompleteArray.removeAll()
       self.autoCompleteTableView.reloadData()
       txtField.text = ""
       txtField.resignFirstResponder()
       iconImageView.isHidden = false

       switch segmentControl.selectedSegmentIndex
       {
        case 0:
          elementArray = PGDataManager.getDrugList()
        break
        default:
          elementArray = PGDataManager.getDrugUseList()
        break;
       }
     }
    
    @IBAction func revealMenu(_ sender: Any) {
        
        self.slidingViewController().anchorTopViewToRight(animated: true)
    }
    
    @IBAction func unwind(fromDisclaimertoHome segue: UIStoryboardSegue) {
        //NSLog(@"current date000: %@", [NSDate date]);
        if !self.presentedViewController!.isBeingDismissed {
            
            self.dismiss(animated: true, completion: { _ in })
        }
    }
    
    // Take string from Search Textfield and compare it with autocomplete array
    func searchAutocompleteEntries(withSubstring substring: String) {
        // Put anything that starts with this substring into the autoCompleteArray
        // The items in this array is what will show up in the table view
        autoCompleteArray.removeAll()
        for curString: String in elementArray {
            
            let substringRangeUpperCase = (curString.uppercased() as NSString).range(of: substring.uppercased())
            
            if substringRangeUpperCase.location == 0 {
                
                 autoCompleteArray.append(curString)
            }
        }
        
        if autoCompleteArray.isEmpty
        {
             iconImageView.isHidden = false
            
        } else {
            
             iconImageView.isHidden = true
        }
        autoCompleteTableView.isHidden = false
        autoCompleteTableView.reloadData()
    }
    
    // Close keyboard if the Background is touched
    func touchesBegan(_ touches: Set<AnyHashable>, with event: UIEvent) {
        self.view.endEditing(true)
        super.touchesBegan(touches as! Set<UITouch>, with: event)
        self.finishedSearching()
    }
    
    
    // MARK: -
    // MARK: - UITextField Delegate Methods
    // MARK: -
    
    // Close keyboard when Enter or Done is pressed
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        self.finishedSearching()
        return true
    }
    // String in Search textfield
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        self.searchAutocompleteEntries(withSubstring: newString!)
        return true
    }
    
    
    // MARK: -
    // MARK: - UITableView Delegate Methods
    // MARK: -
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteRowIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
       
        cell!.textLabel!.text = autoCompleteArray[indexPath.row]
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)!
        txtField.text = selectedCell.textLabel!.text
        self.finishedSearching()
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
             self.performSegue(withIdentifier: "showDrug", sender: self)
            break
        default:
             self.performSegue(withIdentifier: "showUse", sender: self)
            break;
        }
       
    }
    
    
    // MARK: -
    // MARK: - UINavigation Delegate Methods
    // MARK: -
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if (identifier == "showDrug" || identifier == "showUse" ) {
            
            if txtField.text?.characters.count == 0 {
              
                return false
            }
           }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier! == "showDrug") {
        
            let vc = segue.destination as! PGWebViewController
            if (txtField.text?.characters.count)! > 0 {
                
               vc.setDrug(txtField.text!)
            }
            else {
              
               vc.setDrug(shortCutItemDrug!)
            }
        } else if (segue.identifier == "showUse")  {
            
            let vc = segue.destination as! PGDrugListViewController
            vc.drugList = PGDataManager.getDrugNameList(byIndication: txtField.text!)
        }
    }
    
   
    
    
    // MARK: -
    // MARK: - Keyboard Notification Methods
    // MARK: -
    
    func keyboardWillShow(_ note: Notification) {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let screenHeight: CGFloat = screenRect.size.height
        
        var info = note.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardFrame.size.height
      
        // Detect orientation
        let orientation = UIApplication.shared.statusBarOrientation
        // Reduce size of the Table view
        if orientation == .portrait || orientation == .portraitUpsideDown {
            //txtField.frame =CGRectMake(5, 70, screenWidth-10, 41);
            barHeightP = Float(self.navigationController!.navigationBar.frame.size.height) + Float(UIApplication.shared.statusBarFrame.size.height)
            
            self.autoCompleteTableView.frame.size.height = CGFloat(screenHeight - CGFloat(barHeightP) - 80 - CGFloat(keyboardHeight))
           
        } else {
            
            barHeightL =  Float(self.navigationController!.navigationBar.frame.size.height) + Float(UIApplication.shared.statusBarFrame.size.height)
            if screenHeight > screenWidth {
              
                 self.autoCompleteTableView.frame.size.height = CGFloat(screenHeight - CGFloat(barHeightL) - 80 - CGFloat(keyboardHeight))
            }
        }
    }
    
    func keyboardWillHide(_ note: Notification) {

        self.view.layoutIfNeeded()
    }
}
