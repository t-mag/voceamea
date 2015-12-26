//
//  GlobalsFunctions_class.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 20/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Globals.h"

@interface GlobalsFunctions_class : NSObject

-(CGRect)getViewSize:(UIView*)viewX;
-(CGSize)getScreenSize;
-(CGSize)calcWorkScreenSize;
-(CGSize)calcCellSizewith_CollectionViewSize:(CGSize)collViewSize;


//-(void)dismissKeyboard:(id)obj;
//    [aTextField resignFirstResponder];
//}


-(NSString*)getFullDirectoryPathfor:(NSString*)sDirName;
-(UIImage*)resizeImage:(UIImage*)image;

-(void)msgboxInfo:(NSString*)message dismissafter:(int)seconds;
//-(NSString *)hexStringForColor:(UIColor *)color;
//-(UIColor *)colorWithHexString:(NSString *)hexString;
-(NSArray*)Color2RGB:(UIColor*)color;
-(UIColor*)RGB2Color:(NSString*)strRGB;
-(NSString*)RGB2String:(NSArray*)arrayRGBvalues;

-(NSString*)repairString4UseAsFilename:(NSString*)str;
-(NSString*)removeFilePrefix:(NSString*)strFileName prefixIs:(NSString*)strPrefix;

-(NSArray*)getAllFontsAvailable;



-(void)PrintOut_matrix:(NSArray*)matrixArray showIndex:(BOOL)showIndex showMark:(BOOL)showMark;
-(void)PrintOut_array:(NSArray *)array showXY:(BOOL)showXY showMARK:(BOOL)showMark;




- (void) logAllUserDefaults;

@end
