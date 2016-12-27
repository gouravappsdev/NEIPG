//
//  PGViewController.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/21/16.
//  Copyright © 2016 Yaogeng Cheng. All rights reserved.
//

import UIKit

class PGViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "IMG_0410.JPG")!
        self.imageView! = UIImageView(image: image)
        var rect = CGRect()
        
        rect.origin = CGPoint(x: CGFloat(0.0), y: CGFloat(0.0))
        rect.size = image.size
        self.imageView!.frame = rect
        self.scrollView.addSubview(self.imageView!)
        self.scrollView.contentSize = image.size

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let scrollViewFrame = self.scrollView.frame
        let scaleWidth: CGFloat = scrollViewFrame.size.width / self.scrollView.contentSize.width
        let scaleHeight: CGFloat = scrollViewFrame.size.height / self.scrollView.contentSize.height
        let minScale: CGFloat = min(scaleWidth, scaleHeight)
        self.scrollView.minimumZoomScale = minScale
        self.scrollView.maximumZoomScale = 1.0
        self.scrollView.zoomScale = minScale
        //[self centerScrollViewContents];
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
