//
//  EasyAlertView.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 10/8/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "EasyAlertView.h"

@implementation EasyAlertView


+ (id)showWithTitle:(NSString *)title message:(NSString *)message alertStyle:(UIAlertViewStyle)alertViewstyle usingBlock:(void (^)(NSUInteger))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    EasyAlertView * alert = [[EasyAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:cancelButtonTitle
                                                otherButtonTitles:nil];
    
    alert.delegate = alert;
    alert->_block = [block copy];
    
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *buttonTitle = otherButtonTitles; buttonTitle != nil; buttonTitle = va_arg(args, NSString*))
    {
        [alert addButtonWithTitle:buttonTitle];
    }
    va_end(args);
    
    [alert setAlertViewStyle:alertViewstyle];
    
    [alert show];
    
    
    return alert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_block)
    {
        NSMutableArray* array = [[NSMutableArray alloc]init];

        if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput || [alertView alertViewStyle] == UIAlertViewStyleSecureTextInput)
        {
            [array addObject:[alertView textFieldAtIndex:0].text];
        }
        
        if ([alertView alertViewStyle] == UIAlertViewStyleLoginAndPasswordInput)
        {
            [array addObject:[alertView textFieldAtIndex:0].text];
            [array addObject:[alertView textFieldAtIndex:1].text];
        }
        
        _block(buttonIndex,array);

    }
    
}


//-(void)alertView:(UIAlertView *)alertView setAlertStyle:(UIAlertViewStyle)alertStyle
////+(id)setAlertStyle:(UIAlertViewStyle*)alertStyle
//{
//    
//    if (alertStyle < 0) {
//        [alertView setAlertViewStyle:UIAlertViewStyleDefault];
//    }
//    else
//        [alertView setAlertViewStyle:alertStyle];
//
//        
//    
//}

@end
