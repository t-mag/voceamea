//
//  EditCell_FRAME_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/16/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import "EditCell_FRAME_viewcontroller.h"
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "CustomButton_class.h"
#import "NEOColorPickerViewController.h"
#import "SplitView_manual_viewcontroller.h"



@interface EditCell_FRAME_viewcontroller ()
@property GlobalsFunctions_class* globalFuncs;
@property SplitView_manual_viewcontroller* splitView;
// ---------
@property CustomButton_class* btnBackColor;
@property CustomButton_class* btnFrameColor;
@property UISlider* sldBorderWidth;
@property UIImageView* imageExample;
@property UILabel* lblBorderWidth;

@end

@implementation EditCell_FRAME_viewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   _splitView = (id)self.parentViewController.parentViewController;    
 
    _btnBackColor = [[CustomButton_class alloc]init];
    _btnFrameColor = [[CustomButton_class alloc]init];
    _sldBorderWidth = [[UISlider alloc]init];
    _lblBorderWidth = [[UILabel alloc]init];
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setTitle:@"Frame and Background"];
    
}

-(void)viewWillLayoutSubviews
{
    [self re_arangeObjects];
    [self updateFields];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)re_arangeObjects
{
    
    
    CGRect viewRect = [_globalFuncs getViewSize:self.view];
    
    
    
    // float topBorder = TOOLBARHIGH + 10;
    
    NSLog(@"BASIC - re_arangeObjects");
    float XX,YY,WW,HH;
    CGSize thisObj;
    int fullWidth = self.view.frame.size.width - 10;
    int labelWidth = 200;
    int labelHeight = 30;
    int textWidth = 200;
    int textHeight = 30;
    CGSize btnColor = CGSizeMake(130, 30);
    
    int distY_lbl2txt = 5;
    int distX_fromLeft = 10;
    int distX_lbl2btn = 15;
    int distY_line2line = 15;
    int distX_col2col = 20;
    
    
    UIFont* userFont = [UIFont fontWithName:@"System" size:14];
    UIFont* descrFont = [UIFont fontWithName:@"System" size:12];
    
    float topY = self.navigationController.navigationBar.frame.size.height+10;
    
    // --------------- IMAGE CELL EXAMPLE ----------------
    
    _imageExample = [[UIImageView alloc]init];
    _imageExample.layer.borderWidth = 2.0f;
    _imageExample.layer.borderColor = [UIColor blueColor].CGColor;

    WW = 100;
    HH = 100;
    XX = (self.view.frame.size.width - WW)/2;
    YY = topY;
   
    
    [_imageExample setFrame:CGRectMake(XX, YY, WW, HH)];
    
    [self.view addSubview:_imageExample];
    
  //   self.layer.cornerRadius = 5.0f;

    
    //---------------- BACKGROUND COLOR ---------------
    
    UILabel* lblBackColor = [[UILabel alloc]init];
    [lblBackColor setText:@"Background Color"];
    [lblBackColor setFont:descrFont];
    
    thisObj = lblBackColor.frame.size;
    XX = distX_fromLeft;
    YY = _imageExample.frame.origin.y + _imageExample.frame.size.height + distY_line2line+20;
    WW = labelWidth;
    HH = labelHeight;
    
    [lblBackColor setFrame:CGRectMake(XX,YY,WW,HH)];
    [self.view addSubview:lblBackColor];
    
    
    [_btnBackColor setHidden:FALSE];
    _btnBackColor.userData = @"background";
    [_btnBackColor addTarget:self action:@selector(showColor:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBackColor setBackgroundColor:[UIColor lightGrayColor]];
   
    //        if (currentBackColor != nil)
    //            [_btnBackColor setBackgroundColor:currentBackColor];
    //        else
    //            [_btnBackColor setBackgroundColor:CELLDEFAULTBACKGROUNDCOLOR];
    
    
    
    thisObj = _btnBackColor.frame.size;
    WW = btnColor.width;
    HH = btnColor.height;
    
    XX = fullWidth - btnColor.width;
    YY = lblBackColor.frame.origin.y;
    
    [_btnBackColor setFrame:CGRectMake(XX,YY,WW,HH)];
    //   _btnBackColor.userData = [NSValue valueWithCGPoint:CGPointMake(_btnBackColor.frame.origin.x+_btnBackColor.frame.size.width, _btnBackColor.frame.origin.y)];
    [self.view addSubview:_btnBackColor];
    
    //----------- DRAW a Line SEPARATOR --------------
    
    UILabel* lblSeparator = [[UILabel alloc]init];
    [lblSeparator setBackgroundColor:[UIColor blackColor] ];
    
    WW = fullWidth - 30;
    HH = 3;
    XX = (self.view.frame.size.width - WW)/2;
    YY = lblBackColor.frame.origin.y+lblBackColor.frame.size.height+20;
    
    [lblSeparator setFrame:CGRectMake(XX,YY,WW,HH)];
    
    [self.view addSubview:lblSeparator];
    
    
    //---------------- BORDER COLOR ---------------
    
    UILabel* lblBorderColor = [[UILabel alloc]init];
    [lblBorderColor setText:@"Border Color"];
    [lblBorderColor setMinimumScaleFactor:.7f];
    
    thisObj = lblBorderColor.frame.size;
    XX = distX_fromLeft;
    YY = lblSeparator.frame.origin.y + lblSeparator.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    
    [lblBorderColor setFrame:CGRectMake(XX,YY,WW,HH)];
    [self.view addSubview:lblBorderColor];
    
    // todo - module "showFontColor" for fontcolor
    
  
    [_btnFrameColor setHidden:FALSE];
    _btnFrameColor.userData = @"border";
    [_btnFrameColor addTarget:self action:@selector(showColor:) forControlEvents:UIControlEventTouchUpInside];
    [_btnFrameColor setBackgroundColor:[UIColor lightGrayColor]];
    //        if (currentBackColor != nil)
    //            [_btnFrameColor setBackgroundColor:currentFrameColor];
    //        else
    //            [_btnFrameColor setBackgroundColor:CELLDEFAULTFRAMECOLOR];
    //
    thisObj = _btnFrameColor.frame.size;
    WW = btnColor.width;
    HH = btnColor.height;
    XX = fullWidth - btnColor.width;
    YY = lblBorderColor.frame.origin.y;
    
    
    [_btnFrameColor setFrame:CGRectMake(XX,YY,WW,HH)];
    
    [self.view addSubview:_btnFrameColor];
    
    //---------------- BORDER WIDTH ---------------
    
 
    [_lblBorderWidth setText:@"Border width"];
    [_lblBorderWidth setMinimumScaleFactor:.7f];
    
    thisObj = _lblBorderWidth.frame.size;
    XX = lblBorderColor.frame.origin.x;
    YY = lblBorderColor.frame.origin.y + lblBorderColor.frame.size.height + distY_line2line + 5;
    WW = labelWidth;
    HH = labelHeight;
    
    [_lblBorderWidth setFrame:CGRectMake(XX,YY,WW,HH)];
    [self.view addSubview:_lblBorderWidth];
    
    //todo - deal with pickerview
    
    int iMinSize = 3;
    int iMaxSize = 20;
    
    
    [_sldBorderWidth setMaximumValue:iMaxSize];
    [_sldBorderWidth setMinimumValue:iMinSize];
    [_sldBorderWidth setValue:(iMaxSize-iMinSize)/2 animated:TRUE];
    [_sldBorderWidth addTarget:self action:@selector(didSlideChangeValue) forControlEvents:UIControlEventTouchDragInside];
    
    thisObj = _sldBorderWidth.frame.size;
    XX = distX_fromLeft;
    YY = _lblBorderWidth.frame.origin.y + _lblBorderWidth.frame.size.height + distY_lbl2txt+iMaxSize;
    WW = fullWidth;
    HH = labelHeight/2;
    [_sldBorderWidth setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:_sldBorderWidth];
    
    
    UILabel* lblMin = [[UILabel alloc]init];
    [lblMin setText:@"I"];
    [lblMin setFont:[UIFont systemFontOfSize:iMinSize]];
    thisObj = lblMin.frame.size;
    WW = iMinSize;
    HH = iMinSize;
    XX = distX_fromLeft+5;
    YY = _sldBorderWidth.frame.origin.y -iMinSize;
    [lblMin setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:lblMin];
    
    
    
    UILabel* lblMax = [[UILabel alloc]init];
    [lblMax setText:@"I"];
    [lblMax setFont:[UIFont systemFontOfSize:iMaxSize]];
    thisObj = lblMax.frame.size;
    WW = iMaxSize;
    HH = iMaxSize;
    XX = fullWidth - iMaxSize;
    YY = _sldBorderWidth.frame.origin.y - iMaxSize;
    [lblMax setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:lblMax];
    
}

-(void)showColor:(CustomButton_class*)sender
{
    
    NSLog(@"show colors dialogbox");
    
    
    
    
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];//WithNibName:nil bundle:nil];
    controller.delegate = (id)self;
    //controller.selectedColor = self.currentColor;
    
    NSString* btnID = sender.userData;
    if ([btnID isEqualToString:@"border"]) {
        controller.title = @"Frame Color";

    }
    if ([btnID isEqualToString:@"background"]) {
        controller.title = @"Background Color";

    }
   
    
    [self.navigationController showViewController:controller sender:self];
    
}

-(void)didSlideChangeValue
{
   // [_lblFontSize setFont:[UIFont systemFontOfSize:_sldFontSize.value]];
    _splitView.tempCellProperties.cellBorderWidth =_sldBorderWidth.value;
    _imageExample.layer.borderWidth = _sldBorderWidth.value;
    [_lblBorderWidth setText:[NSString stringWithFormat:@"Border width - %d",(int)_sldBorderWidth.value]];
    
    
}

-(void)updateFields
{
    _imageExample.layer.backgroundColor = _splitView.cellEditProperties.cellBackgroundColor.CGColor;
    _imageExample.layer.borderColor = _splitView.cellEditProperties.cellBorderColor.CGColor;
    _imageExample.layer.borderWidth = _splitView.cellEditProperties.cellBorderWidth;
    
    [_btnBackColor setBackgroundColor:_splitView.cellEditProperties.cellBackgroundColor];
    [_btnFrameColor setBackgroundColor:_splitView.cellEditProperties.cellBorderColor];
    [_sldBorderWidth setValue:_splitView.cellEditProperties.cellBorderWidth];
    [_lblBorderWidth setText:[NSString stringWithFormat:@"Border width - %d",(int)_sldBorderWidth.value]];
}

#pragma mark DELEGATES

#pragma mark colorPicker

- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didSelectColor:(UIColor *)color
{
   
    if ( [controller.title isEqualToString:@"Frame Color"]) {
        _splitView.tempCellProperties.cellBorderColor=color; //[UIColor colorWithCGColor:color.CGColor];
        [_btnFrameColor setBackgroundColor:color];
        _imageExample.layer.borderColor = color.CGColor;
        
        
    }
    if ( [controller.title isEqualToString:@"Background Color"]) {
        [_btnBackColor setBackgroundColor:color];
        
        _splitView.tempCellProperties.cellBackgroundColor=_btnBackColor.backgroundColor;
        _imageExample.backgroundColor = color;
        
    }

    
    
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}
- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller
{
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

@end
