//
//  ViewController.swift
//  WebViewScreenShot
//
//  Created by Zmsky on 15/11/9.
//  Copyright © 2015年 http://xloli.net . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var resultImage : UIImage!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func screenShot() -> UIImage{
        UIGraphicsBeginImageContext(self.webView.bounds.size);
        self.webView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let resultingImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return resultingImage
    }
    
    func addImage(image1:UIImage!,image2:UIImage!) -> UIImage{
        
        let size = CGSizeMake(image2.size.width , image1.size.height + image2.size.height)
        
        UIGraphicsBeginImageContext(size)
        
        UIGraphicsGetCurrentContext()
        
        // Draw iamge1
        image1.drawInRect(CGRectMake(0, 0, image1.size.width, image1.size.height))
        
        // Draw image2
        image2.drawInRect(CGRectMake(0, image1.size.height, image2.size.width, image2.size.height))
        
        let resultingImage : UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultingImage
    }
    
    func getSubImage(image:CGImageRef,rect:CGRect) -> UIImage{
        let subImageRef = CGImageCreateWithImageInRect(image, rect)
        let smallBounds = CGRectMake(0, 0, CGFloat(CGImageGetWidth(subImageRef)), CGFloat(CGImageGetHeight(subImageRef)))
        
        UIGraphicsBeginImageContext(smallBounds.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawImage(context, smallBounds,subImageRef)
        let smallImage = UIImage(CGImage: subImageRef!)
        UIGraphicsEndImageContext()
        
        return smallImage;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let nextViewController = segue.destinationViewController as! ResultViewController
        nextViewController.image = self.resultImage;
        
    }
    
    
    @IBAction func screenShotAction(sender: AnyObject) {
       
        
        let viewHeight = Int(self.webView.bounds.size.height);
        let pageHeight = Int(self.webView.scrollView.contentSize.height);
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            var current = 0
            let totalCount = Int(pageHeight / viewHeight) + 1
            var screenShotImage : UIImage!
            
            for(current = 0 ; current < totalCount ; current++ ){
            
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let y = current * viewHeight
                    self.webView.scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: false)
                })
                
                NSThread.sleepForTimeInterval(0.3)
                
                let image = self.screenShot()
                
                if current == 0 {
                    screenShotImage = UIImage(CGImage:image.CGImage!)
                    continue
                }else{
                    screenShotImage = self.addImage(screenShotImage, image2: image)
                }
                
            }
            
            print(screenShotImage)
            self.resultImage = self.getSubImage(screenShotImage.CGImage!, rect: CGRectMake(0,0,self.webView.frame.size.width,CGFloat(pageHeight)))//screenShotImage;
            
            self.performSegueWithIdentifier("ShowResult", sender: screenShotImage)
            
        }
        
    }
    
    @IBAction func openPageAction(sender: AnyObject) {
        
        let url = NSURL(string:"http://xloli.net/comments")
        let request = NSURLRequest(URL: url!)
        
        self.webView.loadRequest(request)
        
    }
    

}

