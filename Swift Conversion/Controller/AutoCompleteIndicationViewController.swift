
//
//  AutoCompleteIndicationViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/21/16.
//  Copyright © 2016 Yaogeng Cheng. All rights reserved.
//

import UIKit

class AutoCompleteIndicationViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var autoCompleteArray = [String]()
    private var elementArray = [String]()
    private var lowerCaseElementArray = [String]()
    private var txtField: UITextField!
    private var autoCompleteTableView: UITableView!
    private var tableHeight: Float = 0.0
    private var barHeightP: Float = 0.0
    private var barHeightL: Float = 0.0
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
        autoCompleteTableView.isHidden = true
    }
    
    
    // MARK: -
    // MARK: - View Life Cycle Methods
    // MARK: -
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "Look Up by Use"
        txtField.text = ""
        let orientation = UIApplication.shared.statusBarOrientation
        let screenRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let screenHeight: CGFloat = screenRect.size.height
        
        if orientation == .portrait || orientation == .portraitUpsideDown {
            
            barHeightP = Float(self.navigationController!.navigationBar.frame.size.height) + Float(UIApplication.shared.statusBarFrame.size.height)
            txtField.frame = CGRect(x: CGFloat(5), y: CGFloat(barHeightP + 5), width: CGFloat(screenWidth - 10), height: CGFloat(40))
            //autoCompleteTableView.frame = CGRectMake(0, 106, screenWidth-10, screenHeight-45-keyboardHeight);
        }
        else if orientation == .landscapeLeft || orientation == .landscapeRight {
            barHeightL = Float(self.navigationController!.navigationBar.frame.size.height) + Float(UIApplication.shared.statusBarFrame.size.width)
            //for 6s and before, the screen height and width does not change when rotate, but for 6s it does change when rotate.
            if screenHeight > screenWidth {
                txtField.frame = CGRect(x: CGFloat(5), y: CGFloat(barHeightL + 5), width: CGFloat(screenHeight - 10), height: CGFloat(40))
            }
            else {
                txtField.frame = CGRect(x: CGFloat(5), y: CGFloat(barHeightL + 5), width: CGFloat(screenWidth - 10), height: CGFloat(40))
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name:NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = nil
        super.viewWillDisappear(animated)
    }
    
    func orientationChanged(_ notification: Notification) {
        self.adjustViews(for: UIApplication.shared.statusBarOrientation)
    }
    
    func adjustViews(for orientation: UIInterfaceOrientation) {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let screenHeight: CGFloat = screenRect.size.height
        if orientation == .portrait || orientation == .portraitUpsideDown {
            barHeightP = Float(self.navigationController!.navigationBar.frame.size.height) + Float(UIApplication.shared.statusBarFrame.size.height)
            txtField.frame = CGRect(x: CGFloat(5), y: CGFloat(barHeightP + 5), width: CGFloat(screenWidth - 10), height: CGFloat(40))
            //autoCompleteTableView.frame = CGRectMake(0, 106, screenWidth-10, screenHeight-45-keyboardHeight);
        } else if orientation == .landscapeLeft || orientation == .landscapeRight {
            barHeightL = Float(self.navigationController!.navigationBar.frame.size.height) + Float(UIApplication.shared.statusBarFrame.size.width)
            if screenHeight > screenWidth {
                txtField.frame = CGRect(x: CGFloat(5), y: CGFloat(barHeightL + 5), width: CGFloat(screenHeight - 10), height: CGFloat(40))
            }
            else {
                txtField.frame = CGRect(x: CGFloat(5), y: CGFloat(barHeightL + 5), width: CGFloat(screenWidth - 10), height: CGFloat(40))
            }
            //autoCompleteTableView.frame = CGRectMake(0, 106, screenHeight-10, screenWidth-45-keyboardHeight);
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIDeviceOrientationDidChange , object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHeight = 40
        barHeightP = 64
        barHeightL = 52
        // Register notification when the keyboard will be show
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        elementArray = PGDataManager.getDrugUseList()
        //Search Bar
        txtField = UITextField(frame: CGRect(x: CGFloat(5), y: CGFloat(70), width: CGFloat(261), height: CGFloat(40)))
        txtField.borderStyle = UITextBorderStyle(rawValue: 3)!
        // rounded, recessed rectangle
        //txtField.layer.borderWidth = 1;
        //txtField.layer.borderColor = [[UIColor redColor] CGColor];
        txtField.layer.cornerRadius = 8.0
        txtField.layer.masksToBounds = true
        txtField.layer.borderColor = UIColor.black.cgColor
        txtField.layer.borderWidth = 1.0
        
        txtField.placeholder = "Enter drug name here"
        txtField.delegate = self
        self.view.addSubview(txtField)
        
        let m_icon1 = UIImage(named: "nei_logo")!
        let imageView1 = UIImageView(image: m_icon1)
        //imageView.frame = CGRectMake(0,110,261, 40);
        var frame1 = imageView1.frame
        frame1.origin.x = self.view.bounds.midX - imageView1.bounds.midX
        
        
        
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
        
        imageView1.frame = frame1
        imageView1.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        self.view.addSubview(imageView1)
        
        autoCompleteTableView = UITableView(frame: CGRect(x: CGFloat(0), y: CGFloat(106), width: CGFloat(259), height: CGFloat(4 * tableHeight)), style: .plain)
        autoCompleteTableView.delegate = self
        autoCompleteTableView.dataSource = self
        autoCompleteTableView.isScrollEnabled = true
        autoCompleteTableView.isHidden = true
        autoCompleteTableView.rowHeight = CGFloat(tableHeight)
        autoCompleteTableView.separatorColor = UIColor.clear
        self.view.addSubview(autoCompleteTableView)
        
        let orientation = UIApplication.shared.statusBarOrientation
        let screenRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let screenHeight: CGFloat = screenRect.size.height
        if orientation == .portrait || orientation == .portraitUpsideDown {
            barHeightP = Float(self.navigationController!.navigationBar.frame.size.height) +  Float(UIApplication.shared.statusBarFrame.size.height)
            txtField.frame = CGRect(x: CGFloat(5), y: CGFloat(barHeightP + 5), width: CGFloat(screenWidth - 10), height: CGFloat(40))
            
        }
        else {
            
            barHeightL = Float(self.navigationController!.navigationBar.frame.size.height) + Float(UIApplication.shared.statusBarFrame.size.width)
            //txtField.frame =CGRectMake(5, barHeightL+5, screenHeight-10, 40);
            if screenHeight > screenWidth {
                txtField.frame = CGRect(x: CGFloat(5), y: CGFloat(barHeightL + 5), width: CGFloat(screenHeight - 10), height: CGFloat(40))
            }
            else {
                txtField.frame = CGRect(x: CGFloat(5), y: CGFloat(barHeightL + 5), width: CGFloat(screenWidth - 10), height: CGFloat(40))
            }
            
        }
        self.navigationItem.backBarButtonItem?.title = "Drug"
        
    }
    
    
    // MARK: -
    // MARK: - Button Action Methods
    // MARK: -
    
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
        self.performSegue(withIdentifier: "showUse", sender: self)
    }
    
    
    // MARK: -
    // MARK: - UINavigation Delegate Methods
    // MARK: -
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
       
            if txtField.text?.characters.count == 0 {
                txtField.text = "Please select an indication."
                return false
            }
            if (txtField.text?.isEqual(("Please select an indication.")))! {
                return false
            }
       
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let vc = segue.destination as! PGDrugListViewController
        vc.drugList = PGDataManager.getDrugNameList(byIndication: txtField.text!) 
    }
    
    
    // MARK: -
    // MARK: - Keyboard Notification Methods
    // MARK: -
    
    func keyboardWillShow(_ note: Notification) {
        //barHeight = self.navigationController.navigationBar.frame.size.height;
        let screenRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let screenHeight: CGFloat = screenRect.size.height
        
        // Get the keyboard size
        let userInfo:NSDictionary = note.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardBounds = keyboardFrame.cgRectValue
        
        // Detect orientation
        let orientation = UIApplication.shared.statusBarOrientation
        //CGRect frame = autoCompleteTableView.frame;
        // Start animation
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)
        
        // Reduce size of the Table view
        if orientation == .portrait || orientation == .portraitUpsideDown {
            //txtField.frame =CGRectMake(5, 70, screenWidth-10, 41);
            barHeightP = Float(self.navigationController!.navigationBar.frame.size.height) + Float(UIApplication.shared.statusBarFrame.size.height)
            autoCompleteTableView.frame = CGRect(x: CGFloat(0), y: CGFloat(barHeightP + 45), width: CGFloat(screenWidth - 10), height: CGFloat(screenHeight - CGFloat(barHeightP) - 45 - CGFloat(keyboardBounds.size.height)))
        }
        else {
            barHeightL =  Float(self.navigationController!.navigationBar.frame.size.height) + Float(UIApplication.shared.statusBarFrame.size.height)
            if screenHeight > screenWidth {
                autoCompleteTableView.frame = CGRect(x: CGFloat(0), y: CGFloat(barHeightL + 45), width: CGFloat(screenHeight - 10), height: CGFloat(screenWidth - CGFloat(barHeightL) - 45 - CGFloat(keyboardBounds.size.width)))
            }
        }
    }
    
    func keyboardWillHide(_ note: Notification) {
    }
}
