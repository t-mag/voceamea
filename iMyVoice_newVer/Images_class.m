//
//  Images_class.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 20/5/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//


#import "Images_class.h"
#import "Globals.h"

@implementation Images_class
@synthesize imgFileName,imgPath,imgShowName,imgCategory,imgCreatedBy,imgCreatedDate,imgDescription,imgIndex,imgLastUpdatedBy,imgLastUpdatedDate,imgPrompt,imgType,appdelegate;


-(id)initWithImageIndex:(NSString*)imageIndex;
{
    [self superclass];
    
    BOOL imgFound = NO;
    AppDelegate* _appDelegate = DELEGATE;
    Images_class* imgX=nil;
    
    
    for (imgX in _appDelegate.arrayOfImages){
        if ([imgX.imgIndex isEqualToString:imageIndex]) {
            imgFound=YES;
            break;
            
        }
    }
    if (imgFound == NO) {
        return nil;
    }
    else
        return imgX;
    
    
}

-(BOOL)updateImageClasswithShowName:(NSString*)sShowName andwithDescription:(NSString*)sDescription andwithFileName:(NSString*)sFileName andwithPath:(NSString*)sPath andwithCategory:(NSString*)sCategory andwithUpdatedDate:(NSDate*) dateUpdated andwithUpdatedDateby:(NSString*)dateUpdatedby andwithPrompt:(NSString*)sPrompt andwithType:(NSString*)sType andwithIndex:(NSString*)nIndex

{
    
   // AppDelegate* _appdelegate = DELEGATE;
    
    if (sFileName == nil || sShowName == nil || nIndex == nil) {
        NSLog(@"updateImageClasswithShowName - MUST supply sFilename, sShowName, nIndex");
        return FALSE;
    }
    
    //self.imgIndex=nIndex == nil?[NSNumber numberWithUnsignedLong:_appdelegate.arrayOfImages.count+1]:nIndex;
    self.imgIndex = nIndex;
    self.imgFileName=sFileName;
    self.imgShowName=sShowName;
    NSString* strPath = [sPath stringByAbbreviatingWithTildeInPath];
    self.imgPath = strPath;

    self.imgDescription=sDescription == nil?sShowName:sDescription;
    self.imgCategory=sCategory == nil?@"":sCategory;
    
    self.imgCreatedBy=@"admin";
    self.imgCreatedDate=[NSDate date];
    self.imgLastUpdatedBy=dateUpdatedby;
    self.imgLastUpdatedDate=dateUpdated;
    
    self.imgPrompt=sPrompt == nil?@"":sPrompt;
    self.imgType=sType == nil?@"":sType;


    
    return TRUE;
 
    
    
    
    
    
}



@end
