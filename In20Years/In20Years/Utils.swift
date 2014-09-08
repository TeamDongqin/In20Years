//
//  Utils.swift
//  i2yt
//
//  Created by giantliu on 14-9-7.
//  Copyright (c) 2014年 giantliu. All rights reserved.
//

import Foundation
import AssetsLibrary

class DQRegex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        var error: NSError?
        self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, countElements(input)))
        return matches.count > 0
    }
    
    func exec(input: String) -> AnyObject[]{
        
        return self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, countElements(input)))
    }
}

/*
-(void)findLargeImage
{
NSString *mediaurl = [self.node valueForKey:kVMMediaURL];

//
ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
{
ALAssetRepresentation *rep = [myasset defaultRepresentation];
CGImageRef iref = [rep fullResolutionImage];
if (iref) {
largeimage = [UIImage imageWithCGImage:iref];
[largeimage retain];
}
};

//
ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
{
NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
};

if(mediaurl && [mediaurl length] && ![[mediaurl pathExtension] isEqualToString:AUDIO_EXTENSION])
{
[largeimage release];
NSURL *asseturl = [NSURL URLWithString:mediaurl];
ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
[assetslibrary assetForURL:asseturl
resultBlock:resultblock
failureBlock:failureblock];
}
}
*/



class DQUtils{
    
    class func findLargeImage(mediaURL:NSString){
        
//        var largeImage:UIImage!;
//        
//        func resultblock(myasset:ALAsset)->ALAssetsLibraryAssetForURLResultBlock{
//            var rep:ALAssetRepresentation = myasset.defaultRepresentation();
//            var iref:CGImageRef = rep.fullResolutionImage().takeUnretainedValue();
//            largeImage = UIImage(CGImage:iref);
//        }
        
    }
    
    /*
    + (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
    {
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
    scale:assetRep.scale
    orientation:(UIImageOrientation)assetRep.orientation];
    return img;
    }
    */
    
    class func fullResolutionImageFromALAsset(asset:ALAsset)->UIImage{
        //asset.thumbnail()
        var assetRep:ALAssetRepresentation = asset.defaultRepresentation();
        var imgRef:CGImageRef = assetRep.fullResolutionImage().takeUnretainedValue();
        var img:UIImage = UIImage(CGImage:imgRef);
        return img;
    }
    
    class func getUrlParamValue(urlString url:String,urlParam param:String)->String{
        var reg = DQRegex("(?|&)"+param+"=(\\w+)");
        var res = reg.exec(url);
        
        var resStr:String = "";
        return resStr;
    }
    
    class func showAlert(title:String = "test",content:String = "What do you want!",deleObj del:AnyObject){
        var alert = UIAlertView();
        alert.title = title;
        alert.delegate = del;
        alert.addButtonWithTitle("OK");
        alert.message = content;
        alert.show();
    }
    
}