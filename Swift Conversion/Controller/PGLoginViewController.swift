//
//  PGLoginViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 12/1/16.
//  Copyright © 2016 Mobileprogrammingllc. All rights reserved.
//

import UIKit

class PGLoginViewController: UIViewController, UITextFieldDelegate, XMLParserDelegate, UIScrollViewDelegate {
    
    var myWebData: Data!
    var myXMLParser: XMLParser!
    var currentElementValue: String!
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var errorMsg: UILabel!
    @IBOutlet var signIn: UIButton!
    @IBOutlet var myscrooview: UIScrollView!
    @IBOutlet var roundbutton: UIButton!
    
    var imageView: UIImageView!
    
    var keychainItem: KeychainItemWrapper!
    var encryptpassword = ""
    var encryptusername = ""
    
    var loginStatus : String?
    
    
    // MARK: -
    // MARK: - View Life Cycle Methods
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnLayer = roundbutton.layer
        btnLayer.masksToBounds = true
        btnLayer.cornerRadius = 5.0
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
      
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        keychainItem = KeychainItemWrapper(identifier: "NEIPG", accessGroup: nil)
        
        let passData = keychainItem?.object(forKey: kSecValueData) as? Data
        
        encryptpassword = String(data: passData!, encoding: String.Encoding.utf8)!
        encryptusername = (keychainItem?.object(forKey: kSecAttrAccount) as? String)!
        
        let lastdate = keychainItem?.object(forKey: kSecAttrModificationDate) as? Date
        let createdate = keychainItem?.object(forKey: kSecAttrCreationDate) as? Date
        
        var check = true
        if lastdate != nil
        {
            if createdate != nil
            {
                check = false
                if !encryptusername.isEmpty
                {
                    self.password!.text = encryptpassword
                    self.email.text = encryptusername
                    self.log(in: encryptusername, encryptPasswordin: encryptpassword)
                }
            }
        }
        
        if check
        {
            let dViewController = self.storyboard!.instantiateViewController(withIdentifier: "disclaimer")
            self.present(dViewController, animated: false, completion: { _ in })
        }
    }
    
    
    
    // MARK: -
    // MARK: - Forgot & login function
    // MARK: -
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        
        //check email text validation
        if (self.email.text?.characters.count)! > 0 {
            
            if !self.emailValidation(self.email.text!) {
                self.errorMsg.text = "Invalid email address."
            }
            else
            {
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.labelText = "Requesting password..."
                
                //soap string
                let soapMessageValue = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><requestPassword xmlns='http://www.neiglobal.com/'><email>\(self.email.text)</email></requestPassword></soap:Body></soap:Envelope>"
                let is_URL: String = "https://nws.neiglobal.com/Service1.asmx"
                
                //call web service
                self.callWebService(soapMessage: soapMessageValue, urlString: is_URL, soapAction: "http://www.neiglobal.com/requestPassword")
            }
        }
        else
        {
            self.errorMsg.text = "Enter email address.";
        }
    }
    
    func log(in encryptEmailin: String, encryptPasswordin: String) {
        
        // self.performSegue(withIdentifier: "showMaster", sender: self)
        
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.labelText = "logged In..."
        
        
        let encryptPassword = self.encryptString(encryptPasswordin)
        let encryptEmail = self.encryptString(encryptEmailin)
        
        currentElementValue = ""
        
        let soapMessageValue = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><logIn xmlns='http://www.neiglobal.com/'><email>\(encryptEmail)</email>/n<password>\(encryptPassword)</password>/n<deviceId>\(UIDevice.current.identifierForVendor?.uuidString)</deviceId>/n<launchCount>\(UserDefaults.standard.integer(forKey: "NEIAppLaunchCount"))</launchCount></logIn></soap:Body></soap:Envelope>"
        
        
        let is_URL: String = "https://nws.neiglobal.com/Service1.asmx"
        
        self.callWebService(soapMessage: soapMessageValue, urlString: is_URL, soapAction: "http://www.neiglobal.com/logIn")
        
    }
    
    
    @IBAction func unwind(fromDisclaimer segue: UIStoryboardSegue) {
        
        keychainItem.setObject(Date(), forKey: kSecAttrModificationDate)
    }
    
    
    // MARK: -
    // MARK: - Web Service Call & Parsing Data
    // MARK: -
    
    
    func callWebService(soapMessage : String, urlString : String, soapAction : String)
    {
        let urlValue = NSURL(string: urlString)
        var lobj_Request = URLRequest(url:urlValue as! URL)
        //NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        
        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = soapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue(String(soapMessage.characters.count), forHTTPHeaderField: "Content-Length")
        lobj_Request.addValue(soapAction, forHTTPHeaderField: "SOAPAction")
        
        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            
            //sto animation
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if (data != nil)
            {
                self.parseData(parseData: data!)
            }
            //var strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            if error != nil
            {
                print("Error: " + error.debugDescription)
            }
            
        })
        task.resume()
    }
    
    
    // MARK: -
    // MARK: - XML Parser Delegate Method
    // MARK: -
    
    func parseData(parseData : Data)
    {
        self.myXMLParser = XMLParser(data: parseData)
        // here delegate self means implement xmlParse methods
        self.myXMLParser.delegate = self
        self.myXMLParser.shouldResolveExternalEntities = true
        // parse method - will invoke xmlParserMethods
        self.myXMLParser.parse()
        
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if currentElementValue != nil {
            
            currentElementValue  = string
        }
        else {
            
            self.currentElementValue = self.currentElementValue + string
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if let elementValue = currentElementValue
        {
            if elementValue.isEqual("FAILED") {
                self.errorMsg.text = "Log in failed."
            }
            else if elementValue.substring(to: elementValue.index(elementValue.startIndex, offsetBy: 6)).isEqual("MEMBER") {
                
                UserDefaults.standard.set(0, forKey: "NEIAppLaunchCount")
                if elementValue.characters.count > 6 {
                    
                    let valueToSave = elementValue.substring(from: elementValue.index(elementValue.startIndex, offsetBy: 6))
                    UserDefaults.standard.set(valueToSave, forKey: "NEIGroupName")
                }
                else {
                    UserDefaults.standard.removeObject(forKey: "NEIGroupName")
                }
                
                self.loginStatus = elementValue.substring(to: elementValue.index(elementValue.startIndex, offsetBy: 6))
                
                
                //save info
                keychainItem.resetKeychainItem()
                keychainItem.setObject(encryptpassword, forKey: kSecValueData)
                keychainItem.setObject(encryptusername, forKey: kSecAttrAccount)
                keychainItem.setObject(Date(), forKey: kSecAttrModificationDate)
                
                self.performSegue(withIdentifier: "showMaster", sender: self)
                
            }
            else if elementValue.isEqual("CUSTOMER") {
                self.errorMsg.text = "You must be a member. Please join today."
            }
            else if elementValue.isEqual("DUPLICATE") {
                self.errorMsg.text = "You have had a free trial already."
            }
            else if elementValue.isEqual("SUCCESS") {
                self.errorMsg.text = "Password sent. Please check your email."
            }
            else if elementValue.isEqual("NOTFOUND") {
                self.errorMsg.text = "Email address does not match the User Name on Records."
            }
            else if elementValue.isEqual("MAILERROR") {
                self.errorMsg.text = "Email could not be sent out, please contact customer service."
            }
            else if elementValue.isEqual("ERROR") {
                self.errorMsg.text = "There is an error, please contact customer service."
            }
            else {
                self.errorMsg.text = elementValue
                self.performSegue(withIdentifier: "showMaster", sender: self)
                
            }
        }
    }
    
    

    func encryptString(_ inStr: String) -> String {
        
        let secret = inStr
        let key = "22515216714613359164620314164148123127244177"
        let crypto = StringEncryption()
        let secretData = secret.data(using: String.Encoding.utf8)
        var paddingValue: CCOptions = CCOptions(Int32(bitPattern: UInt32(kCCOptionPKCS7Padding)))
        
        let encryptedData = crypto.encrypt(secretData, key: key.data(using: String.Encoding.utf8), padding: &paddingValue)
        
        return (encryptedData?.base64EncodedString())!
        
    }
    
    
    func emailValidation(_ emailTxt: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailTxt)
    }
    
    
    // MARK: -
    // MARK: - Navigation Methods
    // MARK: -
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        
        if !(self.email.text?.isEmpty)! && !(self.password!.text?.isEmpty)! {
            
            if !self.emailValidation(self.email.text!) {
                self.errorMsg.text = "Invalid email address."
                return false
            }
            encryptpassword = self.password.text!
            print("encrypted data string for export: \(encryptpassword)")
            encryptusername = self.email.text!
            print("encrypted data string for export: \(encryptusername)")
            self.log(in: encryptusername, encryptPasswordin: encryptpassword)
            // do not return YES becasue it is ascrynous method, do perform sequl in connectionDidFinishLoading
            return false
        }
        self.errorMsg.text = "Enter email and password."
        
        return false
    }
    
    
    // MARK: -
    // MARK: - UITextField Delegate Methods
    // MARK: -
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.myscrooview.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat(0)), animated: true)
        if (textField == self.email) || (textField == self.password!) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            self.myscrooview.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat(self.signIn.center.y - 240)), animated: true)
        }
        else {
            self.myscrooview.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat(120)), animated: true)
        }
    }
    
    
}
