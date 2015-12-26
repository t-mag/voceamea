//
//  GlobalsFunctions_class.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 20/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "GlobalsFunctions_class.h"
#import "Cell_class.h"

@implementation GlobalsFunctions_class


-(CGRect)getViewSize:(UIView*)viewX
{
    return CGRectMake(viewX.frame.origin.x, viewX.frame.origin.y, viewX.frame.size.width, viewX.frame.size.height);
}

-(CGSize)getScreenSize
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

-(CGSize)calcWorkScreenSize
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    //    CGRect screenMain = [UIScreen mainScreen].applicationFrame;
    //    CGRect navBar = self.navigationController.navigationBar.frame;
    //CGRect screenSize = screenMain; //screenBound.size;
    CGFloat screenWidth = CGRectGetWidth(screenBound);//   screenSize.width;
    CGFloat screenHeight = CGRectGetHeight(screenBound);//  screenSize.height;
    CGSize screenSize = CGSizeMake(screenWidth, screenHeight);
    return screenSize;
}


-(CGSize)calcCellSizewith_CollectionViewSize:(CGSize)collViewSize
{
    NSLog(@"calcCellSize");
    
//    CGSize screenSize = [self calcWorkScreenSize];
//    
//    [_colEditBoard setFrame:CGRectMake(1, 1, screenSize.width, screenSize.height)];
    
//    float WW = _colEditBoard.frame.size.width;
//    float HH = _colEditBoard.frame.size.height;
    
    float WW = collViewSize.width;
    float HH = collViewSize.height;

    
    float cellWW = WW/NUMOFCELLSINCOL;
    float cellHH = HH/NUMOFCELLSINROW;
    
    //todo - check for each device - checked for ipad air 2 -> OK
    cellHH=cellHH-5.5f;
    return CGSizeMake(cellWW, cellHH);
    
}

//-(void)dismissKeyboard:(id)obj
//{
//   [[obj view] endEditing:TRUE];
//}

-(NSString*)getFullDirectoryPathfor:(NSString*)sDirName
{
    //NSError* error;
    
    NSString* dirLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //    return [dirLibrary stringByAppendingPathComponent:SYMBOLS_MAIN_FOLDER];
    return [dirLibrary stringByAppendingPathComponent:sDirName];
    
    
}

-(UIImage*)resizeImage:(UIImage*)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  img;
}


-(void)msgboxInfo:(NSString*)message dismissafter:(int)seconds
{
    UIAlertView* msgbox = [[UIAlertView alloc]initWithTitle:@"Info !!" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [msgbox show];
    
    [self performSelector:@selector(dismiss:) withObject:msgbox afterDelay:seconds];
    
    //    [self performSelector:@selector(test:) withObject:myal afterDelay:2];
    //    [myal release];
    //    -(void)test:(UIAlertView*)x{
    //        [x dismissWithClickedButtonIndex:-1 animated:YES];
    //   }
    
}

-(void)dismiss:(UIAlertView*) alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
}

//- (NSString *)hexStringForColor:(UIColor *)color {
//    const CGFloat *components = CGColorGetComponents(color.CGColor);
//    CGFloat r = components[0];
//    CGFloat g = components[1];
//    CGFloat b = components[2];
//    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
//    return hexString;
//}
//
//-(UIColor *)colorWithHexString:(NSString *)hexString
//{
////    unsigned int hex;
////    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];
////    int r = (hex >> 16) & 0xFF;
////    int g = (hex >> 8) & 0xFF;
////    int b = (hex) & 0xFF;
////
////    return [UIColor colorWithRed:r / 255.0f
////                           green:g / 255.0f
////                            blue:b / 255.0f
////                           alpha:1.0f];
//
//  //  (UIColor *) colorWithHexString: (NSString *) hexString {
//        NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
//        CGFloat alpha, red, blue, green;
//        switch ([colorString length]) {
//            case 3: // #RGB
//                alpha = 1.0f;
//                red   = [self colorComponentFrom: colorString start: 0 length: 1];
//                green = [self colorComponentFrom: colorString start: 1 length: 1];
//                blue  = [self colorComponentFrom: colorString start: 2 length: 1];
//                break;
//            case 4: // #ARGB
//                alpha = [self colorComponentFrom: colorString start: 0 length: 1];
//                red   = [self colorComponentFrom: colorString start: 1 length: 1];
//                green = [self colorComponentFrom: colorString start: 2 length: 1];
//                blue  = [self colorComponentFrom: colorString start: 3 length: 1];
//                break;
//            case 6: // #RRGGBB
//                alpha = 1.0f;
//                red   = [self colorComponentFrom: colorString start: 0 length: 2];
//                green = [self colorComponentFrom: colorString start: 2 length: 2];
//                blue  = [self colorComponentFrom: colorString start: 4 length: 2];
//                break;
//            case 8: // #AARRGGBB
//                alpha = [self colorComponentFrom: colorString start: 0 length: 2];
//                red   = [self colorComponentFrom: colorString start: 2 length: 2];
//                green = [self colorComponentFrom: colorString start: 4 length: 2];
//                blue  = [self colorComponentFrom: colorString start: 6 length: 2];
//                break;
//            default:
//                [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
//                break;
//        }
//        return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
//
//
//}

//-(CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
//    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
//    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
//    unsigned hexComponent;
//    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
//    return hexComponent / 255.0;
//}

-(NSArray*)Color2RGB:(UIColor*)color
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    CGFloat hue = 0.0, saturation = 0.0, brightness = 0.0;
    
    
    // iOS 5
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        // < iOS 5
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    
    // This is a non-RGB color
    if(CGColorGetNumberOfComponents(color.CGColor) == 2) {
        [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        
    }
    
    NSMutableArray* returnData = [[NSMutableArray alloc]init];
    
    [returnData addObject:[NSString stringWithFormat:@"%f",red]];//[NSNumber numberWithFloat:red]];
    [returnData addObject:[NSString stringWithFormat:@"%f",green]]; //  [NSNumber numberWithFloat:green]];
    [returnData addObject:[NSString stringWithFormat:@"%f",blue]]; //[NSNumber numberWithFloat:blue]];
    [returnData addObject:[NSString stringWithFormat:@"%f",alpha]]; //[NSNumber numberWithFloat:alpha]];
    [returnData addObject:[NSString stringWithFormat:@"%f",hue]];//[NSNumber numberWithFloat:hue]];
    [returnData addObject:[NSString stringWithFormat:@"%f",saturation]];//[NSNumber numberWithFloat:saturation]];
    [returnData addObject:[NSString stringWithFormat:@"%f",brightness]];//[NSNumber numberWithFloat:brightness]]
    
    return returnData;
    
}

-(NSString*)RGB2String:(NSArray*)arrayRGBvalues
{
    NSString* strColor = @"";
    for (NSString* str in arrayRGBvalues)
    {
        strColor= [strColor stringByAppendingString:str];
        strColor= [strColor stringByAppendingString:@","];
    }
    
    return strColor;
}


-(UIColor*)RGB2Color:(NSString*)strRGB
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    CGFloat hue = 0.0, saturation = 0.0, brightness = 0.0;
    
    NSArray* str = [strRGB componentsSeparatedByString:@","];
    
    red = [str[0] floatValue];
    green = [str[1] floatValue];
    blue = [str[2] floatValue];
    alpha = [str[3] floatValue];
    
    hue = [str[4] floatValue];
    saturation = [str[5] floatValue];
    brightness = [str[6] floatValue];
    
    UIColor* color;
    // if (red != nil && blue!= nil && green != nil && alpha != nil) {
    color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    //
    
    return  color;
    
}


-(NSString*)repairString4UseAsFilename:(NSString*)str;
{
    //to do - don't remove characters inside the text
    str = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@"" ];
    str = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet illegalCharacterSet]] componentsJoinedByString:@"" ];
    str = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet symbolCharacterSet]] componentsJoinedByString:@"" ];
    
    return  str;
}

-(NSString*)removeFilePrefix:(NSString*)strFileName prefixIs:(NSString*)strPrefix
{
    
    NSString* result=@"";
    NSRange replaceRange = [strFileName rangeOfString:strPrefix];
    if (replaceRange.location != NSNotFound){
        result = [strFileName stringByReplacingCharactersInRange:replaceRange withString:@""];
    }
    
    return result;
    
    
}

-(void)PrintOut_matrix:(NSArray*)matrixArray showIndex:(BOOL)showIndex showMark:(BOOL)showMark;{
    //for testing
    
    
   
    NSString* strY=@"";
    
    NSLog(@"       0    1    2    3    4    5    6    7    8    9   10   11");
    NSLog(@"____________________________________________________________");
    NSLog(@"");
    
    
    if (showIndex) {
        
        for (int i=0; i<[matrixArray count]; i++) {
            NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[matrixArray objectAtIndex:i]];
            
            for (int j=0; j<[arrayRow count]; j++) {
                Cell_class* cellZ = [[matrixArray objectAtIndex:i] objectAtIndex:j];
                
                
                NSString* ss = [NSString stringWithFormat:@"%d",cellZ.cellIndex];
                int add = 5 - [ss length];
                
                if (add > 0) {
                    NSString *pad = [[NSString string] stringByPaddingToLength:add withString:@" " startingAtIndex:0];
                    
                    strY = [strY stringByAppendingString:pad];
                    strY = [strY stringByAppendingString:[NSString stringWithFormat:@"%d",cellZ.cellIndex]];
                }
                
                // NSLog(@"merge_cellsfromArray - current cell(%d,%d) index-%d",i,j,cellZ.cellIndex);
                
            }
            NSString* ss = [NSString stringWithFormat:@"%d",i];
            int add = 5 - [ss length];
            NSString* cnt=0;
            if (add > 0) {
                NSString *pad = [[NSString string] stringByPaddingToLength:add withString:@" " startingAtIndex:0];
                
                cnt = [[NSString stringWithFormat:@"%d",i] stringByAppendingString:pad];
                cnt = [cnt stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
            }
            
            NSLog(@" %@ -%@",cnt,strY);
            NSLog(@"---");
            strY=@"";
        }
    }
    
    if (showMark) {
        
        for (int i=0; i<[matrixArray count]; i++) {
            NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[matrixArray objectAtIndex:i]];
            
            for (int j=0; j<[arrayRow count]; j++) {
                Cell_class* cellZ = [[matrixArray objectAtIndex:i] objectAtIndex:j];
                
                NSString* ss;
                if (cellZ.mark4show)
                    ss = @"Y";
                else
                    ss = @"N";
                
                int add = 5 - [ss length];
                
                if (add > 0) {
                    NSString *pad = [[NSString string] stringByPaddingToLength:add withString:@" " startingAtIndex:0];
                    
                    strY = [strY stringByAppendingString:pad];
                    strY = [strY stringByAppendingString:ss];
                }
                
                // NSLog(@"merge_cellsfromArray - current cell(%d,%d) index-%d",i,j,cellZ.cellIndex);
                
            }
            NSString* ss = [NSString stringWithFormat:@"%d",i];
            int add = 5 - [ss length];
            NSString* cnt=0;
            if (add > 0) {
                NSString *pad = [[NSString string] stringByPaddingToLength:add withString:@" " startingAtIndex:0];
                
                cnt = [[NSString stringWithFormat:@"%d",i] stringByAppendingString:pad];
                cnt = [cnt stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
            }
            
            NSLog(@" %@ -%@",cnt,strY);
            NSLog(@"---");
            strY=@"";
        }
        
        
        
    }
    
}

-(void)PrintOut_array:(NSArray *)array showXY:(BOOL)showXY showMARK:(BOOL)showMark
{
    //for testing
   // NSString* strX;
   // NSString* strY=@"";
    
    NSLog(@"   Index     X  ,   Y");
    NSLog(@"_________________________");
    NSLog(@"");
   
    if (showXY) {
        
    
    for (int i=0; i<[array count]; i++) {
        Cell_class* cellZ = [array objectAtIndex:i];
        
        // NSString* ss = [NSString stringWithFormat:@"%d",cellZ.cellIndex];
        
        NSLog(@"cell %d has X=%f , Y=%f",cellZ.cellIndex,cellZ.coordinates.x,cellZ.coordinates.y);
        
    }
    }
    
    if (showMark) {
        
        
        for (int i=0; i<[array count]; i++) {
            Cell_class* cellZ = [array objectAtIndex:i];
            
            NSString* ss;
            if (cellZ.mark)
                ss=@"YES";
            else
                ss=@"NO";
            
            
            //NSLog(@"cell %d mark is %@",cellZ.cellIndex,ss);
            NSLog(@"cell %d collection is %@",cellZ.cellIndex,cellZ.collection);
            
        }
    }

    
}

// List all fonts on iPhone. return the result sorted by name
-(NSArray*)getAllFontsAvailable
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
        
    }
    
    
    return [familyNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
             
    
}


- (void) logAllUserDefaults
{
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    NSArray *values = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allValues];
    for (int i = 0; i < keys.count; i++) {
        NSLog(@"%@: %@", [keys objectAtIndex:i], [values objectAtIndex:i]);
    }
}@end
