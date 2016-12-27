//
//  PGDisclaimerViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/30/16.
//  Copyright © 2016 Mobileprogrammingllc. All rights reserved.
//

import UIKit
import Darwin

class PGDisclaimerViewController: UIViewController {

    
    @IBOutlet weak var dWebView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dWebView?.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "disclaimer", ofType: "htm")!, isDirectory: false)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func disagreePressed(_ sender: Any) {
        exit(0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
