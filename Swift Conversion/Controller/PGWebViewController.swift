//
//  PGWebViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/30/16.
//  Copyright © 2016 Mobileprogrammingllc. All rights reserved.
//

import UIKit

class PGWebViewController: UIViewController,UIWebViewDelegate, UISplitViewControllerDelegate {
    
    @IBOutlet var viewWeb : UIWebView?
    var htmlString : String?
    var drugName : String?
    var wvPopUp : UIWebView?
    var drugPopoverController: UIPopoverController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handlingNavigationControl()
        self.edgesForExtendedLayout = UIRectEdge.top
       
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addGestureRecognizer(self.slidingViewController().panGesture)
        
        if self.drugName?.characters.count == 0 {
            
            self.htmlString = "<html><head></head><body>No drug is selected!</body></html>"
        }
        else {
            self.title = self.drugName
            self.htmlString = PGDataManager.getContent(self.drugName!)
            //self.htmlString=@"<html><head></head><body>No drug is selected!</body></html>";
            print("self.drugName: \(self.drugName)")
            let defaults = UserDefaults.standard
            var item1 = ""
            var item2 = ""
            var item3 = ""
            //NSInteger index = 0;
            if let value = defaults.object(forKey: "NEISHORTCUTITEMS1") {
                
                item1 = value as! String
            }
            
            if let value = defaults.object(forKey: "NEISHORTCUTITEMS2") {
                
                item2 = value as! String
            }
            
            if let value = defaults.object(forKey: "NEISHORTCUTITEMS3") {
                
                item3 = value as! String
            }
            
            if !(self.drugName == item1) && !(self.drugName == item2) && !(self.drugName == item3) {
                
                defaults.set(self.drugName, forKey: "NEISHORTCUTITEMS1")
                defaults.set(item1, forKey: "NEISHORTCUTITEMS2")
                defaults.set(item2, forKey: "NEISHORTCUTITEMS3")
            }
        }
        
        let path = Bundle.main.bundlePath
        let baseURL = URL(fileURLWithPath: path)
        viewWeb?.loadHTMLString(self.htmlString!, baseURL: baseURL)
        viewWeb?.delegate = self
    }
    
    private func handlingNavigationControl()
    {
        self.navigationController?.navigationItem.hidesBackButton = true
        // .... Initiate bar buttons
        let btnBack = UIButton()
        let btnImage:UIImage? = UIImage(named:  "back")
        btnBack.frame = CGRect(x: 0, y: 0, width: btnImage!.size.width, height: btnImage!.size.height)
        btnBack.setBackgroundImage(btnImage, for: UIControlState())
        btnBack.addTarget(self, action: #selector(PGWebViewController.backAction), for: .touchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnBack
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func backAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = request.url!.absoluteString
        
       if url.range(of:".jpg") != nil || url.range(of:".png") != nil || url.range(of:".gif") != nil{
            
            if (wvPopUp != nil) {
                return true
            }
            // 1. we have a 'popup' request - create the new view and display it
            //UIWebView *wv =
            // Add to windows array and make active window
            wvPopUp = self.popUpWebview()
            wvPopUp?.loadRequest(request)
            wvPopUp?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            self.view.addSubview(wvPopUp!)
            return false
       }
        
        return true
    }
    
    
    func popUpWebview() -> UIWebView {
        // Create a web view that fills the entire window, minus the toolbar height
        let webView = UIWebView(frame: CGRect(x: CGFloat(Float(self.view.bounds.origin.x)), y: CGFloat(Float(self.view.bounds.origin.y + 50)), width: CGFloat(Float(self.view.bounds.size.width)), height: CGFloat(Float(self.view.bounds.size.height))))
        webView.scalesPageToFit = true
        webView.delegate = self
        let acceptButton = UIButton(type: .roundedRect)
        acceptButton.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(22), height: CGFloat(22))
        //[acceptButton setTitle:@"Close" forState:UIControlStateNormal];
        acceptButton.setBackgroundImage(UIImage(named: "close")!, for: .normal)
        acceptButton.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        webView.scrollView.addSubview(acceptButton)
        return webView
    }
    
    func buttonClicked() {
        
        viewWeb?.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.drugName
    }
    
    @IBAction func revealMenu(_ sender: Any) {
        
        self.slidingViewController().anchorTopViewToRight(animated: true)
    }
    
    @IBAction func naviagationPressed(_ sender: Any) {
        
        self.slidingViewController().anchorTopViewToRight(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! PGMasterViewController
        vc.setMasterItem(self.drugName!)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        _ = webView.stringByEvaluatingJavaScript(from: "document.getElementById(\"showContent\").style.display=\"none\";")!
    }
    
    
    func setMenuItem(_ newString: String) {
        
        let loadString = "\("window.location.hash='#")\(newString)\("'")"
       _ = self.viewWeb?.stringByEvaluatingJavaScript(from: loadString)
    }
    
    func setDrug(_ newString: String) {
        
        self.drugName = PGDataManager.getGenericDrugName(newString)
        //NSLog(@"_htmlString is %@",_htmlString);
        if self.drugPopoverController != nil {
            self.drugPopoverController.dismiss(animated: true)
        }
     }
    
    func setGenericDrug(_ newString: String) {
        
        self.drugName = newString
        if self.drugPopoverController != nil {
            self.drugPopoverController.dismiss(animated: true)
        }
    }

    func splitViewController(_ splitController: UISplitViewController, willHide viewController: UIViewController, with barButtonItem: UIBarButtonItem, for popoverController: UIPopoverController) {
        barButtonItem.title = NSLocalizedString("Drug", comment: "Drug")
        self.navigationItem.setLeftBarButton(barButtonItem, animated: true)
        self.drugPopoverController = popoverController
    }
    
    func splitViewController(_ splitController: UISplitViewController, willShow viewController: UIViewController, invalidating barButtonItem: UIBarButtonItem) {
        // Called when the view is shown again in the split view, invalidating the button and popover controller.
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.drugPopoverController = nil
    }
    
}
