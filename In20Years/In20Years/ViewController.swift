//
//  ViewController.swift
//  i2yt
//
//  Created by giantliu on 14-9-6.
//  Copyright (c) 2014年 giantliu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var mainImage : UIImageView
    
    @IBOutlet var newImage : UIImageView
    
    var imageId:Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //testTimer();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doUpload(sender : AnyObject) {
        
        println("I am touched up....")
        
        
        var dl=HttpClient()
        dl.contentType="png"
        var url="http://in20years.com/response.php"
        var image=UIImage(named:"3.png")
        var data=UIImageJPEGRepresentation(image, 1.0)
        var dict=NSMutableDictionary()
        dict.setObject(data, forKey:"photofile")
        dict.setObject("upload", forKey:"action")
        dict.setObject("female", forKey: "gender")
        dict.setObject("15", forKey: "age");
        dict.setObject("o", forKey: "drugs");
        dl.downloadNSDataFromPostUrl(url,dic:dict,completionHandler: {(data: NSData?, error: NSError?) -> Void in
            if error{
                println("error=\(error!.localizedDescription)")
                
            }else{
                var json=NSJSONSerialization.JSONObjectWithData(data, options:.MutableContainers, error:nil) as NSDictionary
                println("post_image_dict=\(json)")
                self.imageId = json.valueForKey("key") as Int;
                
                self.doAnotherPost();
            }
            })
    }
    
    func doAnotherPost(){
        
        var dl:HttpClient = HttpClient();
        var url="http://in20years.com/response.php"
        
        var dic=["action":"check","image_id":imageId,"gender":"female"];
        dl.downloadFromPostUrl(url, dic: dic, completionHandler: {(data: NSData?, error: NSError?) -> Void in
            if error{
                println("error=\(error!.localizedDescription)")
            }else{
                var dict=NSJSONSerialization.JSONObjectWithData(data, options:.MutableContainers, error:nil) as? NSDictionary
                println("post_dict=\(dict)")
                
                var ok = dict?["ok"] as Int;
                var ready = dict?["ready"] as Int;
                if(ok == 1 && ready == 1){
                    var result = dict?["result_url"] as String;
                    self.onSetImage(result);
                }
                else {
                    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("doAnotherPost"), userInfo: nil, repeats: false);
                }
            }
            })
    }
    
    func testTimer(){
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("doSmth"), userInfo: nil, repeats: false)
    }
    
    func doSmth(){
        println("i am in a loop")
    }
    
    func onSetImage(url:String){
        let imgURL:NSURL=NSURL(string:url)
        let request:NSURLRequest=NSURLRequest(URL:imgURL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
            let img=UIImage(data:data)
                        self.newImage.image=img
            //            self.imageCache[url]=img
            
            })
    }


}

