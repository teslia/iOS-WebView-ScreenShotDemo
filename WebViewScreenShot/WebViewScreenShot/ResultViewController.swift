//
//  ResultViewController.swift
//  WebViewScreenShot
//
//  Created by Zmsky on 15/11/9.
//  Copyright © 2015年 http://xloli.net . All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
