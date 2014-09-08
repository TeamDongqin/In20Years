//
//  ViewController.swift
//  i2yt
//
//  Created by giantliu on 14-9-6.
//  Copyright (c) 2014年 giantliu. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController,RNFrostedSidebarDelegate,YYImagePickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
                            
    @IBOutlet var mainImage : UIImageView
    
    @IBOutlet var newImage : UIImageView
    
    @IBOutlet var loadingAnimation : UIActivityIndicatorView
    
    @IBOutlet var gender : UILabel;
    var genderVal:String = "male";
    
    @IBOutlet var isDrug : UILabel;
    var isDrugVal:Int = 0
    
    var ageVal:Int = 15;
    @IBOutlet var ageLabel : UILabel
    
    var imageId:Int = 0;
    var images:NSArray?;
    var colors:NSArray?;
    var sideBar:RNFrostedSidebar!;
    var optionIndices:NSMutableIndexSet = NSMutableIndexSet(index:1);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //testTimer();
        // Do any additional setup after loading the view, typically from a nib.
        customInit();
    }
    
    @IBAction func switchAge(sender : AnyObject) {
        if((sender as UISwitch).on){
            ageVal = 15;
            ageLabel.text = "+20";
        }
        else{
            ageVal = 30;
            ageLabel.text = "+30";
        }
    }
    @IBAction func switchDrug(sender : AnyObject) {
        if((sender as UISwitch).on){
            println("now i am not a druger");
            isDrug.text = "否";
            isDrugVal = 0;
        }
        else{
            println("now i am a druger");
            isDrugVal = 1;
            isDrug.text = "是";
        }
    }
    
    @IBAction func switchGender(sender : AnyObject) {
        
        if((sender as UISwitch).on){
            gender.text = "男";
            genderVal = "male";
        }
        else{
            gender.text = "女";
            genderVal = "female";
        }
        
    }
    func customInit(){
        images = NSArray(array:[
            UIImage(named:"gear"),
            UIImage(named:"globe"),
            UIImage(named:"star"),
            UIImage(named:"profile"),
            UIImage(named:"gear"),
            UIImage(named:"star")
            ]);
        
        colors = NSArray(array:[
            UIColor(red:0.9,green:0.8,blue:0.7,alpha:0.9),
            UIColor(red:0.6,green:0.7,blue:0.8,alpha:0.6),
            UIColor(red:0.7,green:0.3,blue:0.5,alpha:0.7),
            UIColor(red:0.3,green:0.6,blue:0.1,alpha:0.8),
            UIColor(red:0.5,green:0.8,blue:0.4,alpha:0.6),
            UIColor(red:0.1,green:0.2,blue:0.7,alpha:0.9)
        ])
        
        sideBar = RNFrostedSidebar();
        sideBar.doInit(images,selectedIndices:self.optionIndices,borderColors:colors);
        sideBar.delegate = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showImageSelector(sender : AnyObject) {
        var imagePickerVC = YYImagePickerController()
        self.presentViewController(imagePickerVC, animated: true, completion: {()->Void in
            println("yy image picker is open up");
            })
        imagePickerVC.delegate = self
        imagePickerVC.numberOfRow = 4
        imagePickerVC.limitMaxSelectNum = 1
    }
    
    func imagePickerDidSelectImages(array:NSArray!){
        
        if (array){
            if(array.count == 1){
                var imageAsset:ALAsset = array.objectAtIndex(0) as ALAsset;
                println("select image ALAssetPropertyURLs is: \(imageAsset.valueForProperty(ALAssetPropertyURLs))");
                println("select image ALAssetPropertyType is: \(imageAsset.valueForProperty(ALAssetPropertyType))");
                println("select image ALAssetPropertyLocation is: \(imageAsset.valueForProperty(ALAssetPropertyLocation))");
                println("select image ALAssetPropertyDuration is: \(imageAsset.valueForProperty(ALAssetPropertyDuration))");
                println("select image ALAssetPropertyOrientation is: \(imageAsset.valueForProperty(ALAssetPropertyOrientation))");
                println("select image ALAssetPropertyDate is: \(imageAsset.valueForProperty(ALAssetPropertyDate))");
                println("select image ALAssetPropertyRepresentations is: \(imageAsset.valueForProperty(ALAssetPropertyRepresentations))");
                println("select image ALAssetPropertyAssetURL is: \(imageAsset.valueForProperty(ALAssetPropertyAssetURL))");
                //var aurl : NSURL = imageAsset.valueForProperty(ALAssetPropertyAssetURL) as NSURL;
                //println("query \(aurl.query); parameterString \(aurl.parameterString)")
                //var qstr:NSString = aurl.query as NSString;
                //var str = NSString(alasseturl);
                //var imageType = DQUtils.getUrlParamValue(urlString : "id=DC521FD5-AEC1-4131-8BFA-0B6C6EAAD7C4&ext=JPG",urlParam: "ext");
                mainImage.image = DQUtils.fullResolutionImageFromALAsset(array.objectAtIndex(0) as ALAsset);
            }
            
            //mainImage.image = UIImage(contentsOfFile: array.objectAtIndex(0) as String);
        }
    }
    
    @IBAction func showSidebar(sender : AnyObject) {
        sideBar.show();
    }
    @IBAction func doUpload(sender : AnyObject) {
        
        loadingAnimation.startAnimating();
        
        var dl=HttpClient()
        dl.contentType="png"
        var url="http://in20years.com/response.php"
        var image=mainImage.image
        var data=UIImageJPEGRepresentation(image, 1.0)
        var dict=NSMutableDictionary();
        dict.setObject(data, forKey:"photofile");
        dict.setObject("upload", forKey:"action");
        dict.setObject(genderVal, forKey: "gender");
        dict.setObject(15, forKey: "age");
        dict.setObject(isDrugVal, forKey: "drugs");
        dl.downloadNSDataFromPostUrl(url,dic:dict,completionHandler: {(data: NSData?, error: NSError?) -> Void in
            self.loadingAnimation.stopAnimating();
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
        loadingAnimation.startAnimating();
        
        var dl:HttpClient = HttpClient();
        var url="http://in20years.com/response.php"
        
        var dic=["action":"check","image_id":imageId];
        dl.downloadFromPostUrl(url, dic: dic, completionHandler: {(data: NSData?, error: NSError?) -> Void in
            self.loadingAnimation.stopAnimating();
            if error{
                println("error=\(error!.localizedDescription)")
            }else{
                var dict=NSJSONSerialization.JSONObjectWithData(data, options:.MutableContainers, error:nil) as? NSDictionary
                
                var ok = dict?["ok"] as Int;
                var ready = dict?["ready"] as Int;
                if(ok == 1 && ready == 1){
                    var result = dict?["result_url"] as String;
                    self.onSetImage(result);
                }
                else if(ok == 1 && ready == 0) {
                    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("doAnotherPost"), userInfo: nil, repeats: false);
                }
                else{
                    DQUtils.showAlert(title: "error",content: dict?["error_text"] as String,deleObj:self);
                    println("error occured: post_dict=\(dict)")
                }
            }
            })
    }
    
    func sidebar(sidebar:RNFrostedSidebar, didTapItemAtIndex index:Int){
        println("Tapped item at index \(index)");
        //sideBar.dismissAnimated(YES,completion)
    }
    
    func sidebar(sidebar:RNFrostedSidebar,didEnable itemEnabled:Bool,itemAtIndex index:Int){
        println("item at index \(index) is enabled:\(itemEnabled)");
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
    
    @IBAction func pickPictureFromCamera(sender : AnyObject) {
        var imagePicker:UIImagePickerController = UIImagePickerController();
        imagePicker.delegate = self;
        if(UIImagePickerController.isSourceTypeAvailable(.Camera)){
            imagePicker.sourceType = .Camera;
        }
        
        self.presentViewController(imagePicker, animated: true, completion: {()->Void in
            println("image picker is opened....");
            })
    }
    
    func imagePickerController(picker:UIImagePickerController,didFinishPickingImage image:UIImage,editingInfo editInfo:NSDictionary){
        println("the picture info is \(editInfo)");
        mainImage.image = image;
    }
    
    func imagePickerController(picker:UIImagePickerController,didFinishPickingMediaWithInfo info:NSDictionary){
        println("i have got some info:\(info)");
        self.dismissViewControllerAnimated(true, completion: {()->Void in
            println("some thing happened...");
        })
    }
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: {()->Void in
            println("the image picker controller is close down");
        })
    }

}

