//
//  InitViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/29/16.
//  Copyright © 2016 Mobileprogrammingllc. All rights reserved.
//

import UIKit

class InitViewController: ECSlidingViewController {
    
    var memberStatus = ""
    var shortCutItem : String = ""
    var keychainItem : KeychainItemWrapper?
    var transitions: METransitions!
    var dynamicTransitionPanGesture: UIPanGestureRecognizer!
    
    
    func transitionsObject() -> METransitions
    {
        if (transitions != nil) {
            return transitions
        }
        self.transitions = METransitions()
        return transitions
    }
    
    func dynamicTransitionPanGestureObject() -> UIPanGestureRecognizer {
        
        if (dynamicTransitionPanGesture != nil) {
            return dynamicTransitionPanGesture
        }
        let namePredicate = NSPredicate(format: "name = %@", METransitionNameDynamic)
        
        let transitionsData = self.transitions.all.filter { namePredicate.evaluate(with: $0) } as? Array<Dictionary<String, AnyObject>>
        
        if let data = transitionsData
        {
            let dynamicTransition  = data[0]["Transition"] as! MEDynamicTransition
            self.dynamicTransitionPanGesture = UIPanGestureRecognizer(target: dynamicTransition, action: #selector(MEDynamicTransition.handlePanGesture(_:)))
        }
        return dynamicTransitionPanGesture
    }

    override func viewDidLoad() {
       
        keychainItem = KeychainItemWrapper(identifier: "NEIPG", accessGroup: nil)//For QA login and disclaimer
      //keychainItem?.resetKeychainItem()
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
        {
            self.underLeftViewController  = controller
        }
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Search")
        {
             self.topViewController = controller
        }
        
       /*
        id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
        if (transition == (id)[NSNull null]) {
            self.delegate = nil;
        } else {
            self.delegate = transition;
        }
 */
        
     
        //**********************for other transition
        
        if let transitionData = self.transitionsObject().all[0] as? Dictionary<String, AnyObject>
        {
            let transition   = transitionData["transition"]
            
            if transition is NSNull
            {
                self.delegate = nil
            }
            else
            {
                self.delegate = transition as! ECSlidingViewControllerDelegate
            }
            
            
            if let transitionName = transitionData["name"] as? String
            {
                if (transitionName == METransitionNameDynamic) {
                    
                    let dynamicTransition = (transition as! MEDynamicTransition)
                    dynamicTransition.slidingViewController = self
                    self.topViewAnchoredGesture = [.tapping, .custom]
                    self.customAnchoredGestures = [self.dynamicTransitionPanGesture]
                    self.navigationController!.view.removeGestureRecognizer(self.panGesture)
                    self.navigationController!.view.addGestureRecognizer(self.dynamicTransitionPanGesture)
                }
                else {
                    
                    self.topViewAnchoredGesture = [.tapping, .panning]
                    self.customAnchoredGestures = []
                    //self.navigationController!.view.removeGestureRecognizer(self.dynamicTransitionPanGestureObject())
                    //self.navigationController!.view.addGestureRecognizer(self.panGesture)
                }
            }
         }
        
         super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMasterItem(_ newString: String) {
        self.memberStatus = newString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do other viewWillAppear stuff...
        
     NotificationCenter.default.addObserver(self, selector:  #selector(InitViewController.applicationDidBecomeActive(notification:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        // Do other viewWillDisappear stuff...
        super.viewWillDisappear(animated)
    }
    
   func applicationDidBecomeActive(notification: NSNotification) {
        
        keychainItem = KeychainItemWrapper(identifier: "NEIPG", accessGroup: nil)
        //For QA login and disclaimer
        //[keychainItem resetKeychainItem];
        
        let lastdate = keychainItem?.object(forKey: kSecAttrModificationDate as Any) as? Date
        let createdate = keychainItem?.object(forKey: kSecAttrCreationDate as Any) as? Date
        let encryptusername = keychainItem?.object(forKey: kSecAttrAccount as Any) as? String
    
        print("lastdate: \(lastdate) createdate: \(createdate) encryptusername: \(encryptusername)")
    
        var check = true
        if lastdate != nil
        {
            if createdate != nil
            {
                if !encryptusername!.isEmpty
                {
                    let then = lastdate! as Date
                    let now = Date()
                    let secondsBetween = now.timeIntervalSince(then)
                    let numberOfDays = secondsBetween / 86400
                    //For QA login and disclaimer
                    //if(numberOfDays>=0)
                    if numberOfDays > 31 {
                        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
                        self.present(loginViewController, animated: false, completion: { _ in })
                    }
                    check = false
                }
            }
        }
        
        if check
        {
            let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController, animated: false, completion: { _ in })
        }
        
        if (self.shortCutItem.characters.count) > 0  {
            
        
            self.handleDynamicShortcutItem()
            self.shortCutItem = ""
        }
    }
    
    func handleDynamicShortcutItem() {
        
        let newTopViewController = self.storyboard!.instantiateViewController(withIdentifier: "Search")
    
        if (shortCutItem == "Search") {
            self.topViewController! = newTopViewController
        }
        else {

            self.topViewController! = newTopViewController
            let vc = (newTopViewController.presentedViewController! as! AutoCompleteTextFieldViewController)
            vc.shortCutItemDrug = shortCutItem
            vc.performSegue(withIdentifier: "showDrug", sender: vc)
 
        }
    }
    
    @IBAction func unwind(fromLogin segue: UIStoryboardSegue) {
       
        if !(self.presentedViewController?.isBeingDismissed)! {
            
            self.dismiss(animated: true, completion: { _ in })
        }
       
    }
}
