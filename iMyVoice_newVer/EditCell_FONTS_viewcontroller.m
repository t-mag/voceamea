//
//  EditCell_FONTS_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/13/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import "EditCell_FONTS_viewcontroller.h"
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "CustomButton_class.h"
#import "Cell_class.h"
#import "ListofObjects_tableviewcontroller.h"
#import "SplitView_manual_viewcontroller.h"
#import "NEOColorPickerViewController.h"

@interface EditCell_FONTS_viewcontroller () <NEOColorPickerViewControllerDelegate>

@property GlobalsFunctions_class* globalFuncs;
@property SplitView_manual_viewcontroller* splitView;
//--------------------------------------
@property Cell_class* cellNewProperties;
@property CustomButton_class* btnFontNameList;
@property UILabel* lblExample;
@property CustomButton_class* btnFontColor;
@property UILabel* lblFontSize;
@property CustomButton_class* btnBackColor;
@property CustomButton_class* btnFrameColor;
@property UISlider* sldFontSize;
@property UISegmentedControl* segmButton;


@end

@implementation EditCell_FONTS_viewcontroller
@synthesize currentBackColor,currentFont,currentFontColor,currentFrameColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _globalFuncs = [[GlobalsFunctions_class alloc]init];
    _splitView = (id)self.parentViewController.parentViewController;
    //----------
    _cellNewProperties = [[Cell_class alloc]init];
    _btnFontColor = [[CustomButton_class alloc]init];
    _btnBackColor = [[CustomButton_class alloc]init];
    _btnFrameColor = [[CustomButton_class alloc]init];
    _btnFontNameList = [[CustomButton_class alloc]init];
    _sldFontSize = [[UISlider alloc]init];
    _segmButton = [[UISegmentedControl alloc]init];
    _lblExample = [[UILabel alloc]init];
    
    
    
    //notifications
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(notificationUserDidSelectFontFromList:) name:@"fontfromList" object:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setTitle:@"Fonts"];
    
}

-(void)viewWillLayoutSubviews
{
    [self re_arangeObjects];
    [self updateFields];
    
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
    
    NSLog(@"FONTS - re_arangeObjects");
    float XX,YY,WW,HH;
    CGSize thisObj;
    int fullWidth = self.view.frame.size.width - 20;
    int labelWidth = 100;
    int labelHeight = 30;
    int textWidth = 200;
    int textHeight = 30;
    CGSize btnColor = CGSizeMake(100, 30);
    
    int distY_lbl2txt = 5;
    int distX_fromLeft = 10;
    int distX_lbl2btn = 15;
    int distY_line2line = 15;
    int distX_col2col = 20;
    
    
    UIFont* descrFont = [UIFont fontWithName:@"System" size:14];
    
    // the image button is the one who dictates the X for the middle objects
    // float centerX = (viewRect.size.width - btnSelectImage.frame.size.width)/2;
    
    float topY = self.navigationController.navigationBar.frame.size.height+10;
    
    
#pragma mark -------------- FONT NAME --------------
    
    // 08-12-2015 - dissabled for later
    
//    UILabel* lblFontName = [[UILabel alloc]init];
//    [lblFontName setText:@"Name"];
//    // [lblFontName setMinimumScaleFactor:.7f];
//    [lblFontName setFont:descrFont];
//    
//    thisObj = lblFontName.frame.size;
//    XX = distX_fromLeft;
//    YY = topY;
//    WW = labelWidth;
//    HH = labelHeight;
//    [lblFontName setFrame:CGRectMake(XX,YY, WW,HH)];
//    
//    [self.view addSubview:lblFontName];
//    
//    //todo - deal with fontlist
//    
//    if (currentFont != nil)
//        [_btnFontNameList setTitle:currentFont.fontName forState:UIControlStateNormal];
//    else
//        [_btnFontNameList setTitle:@"Default" forState:UIControlStateNormal];
//    
//    
//    [_btnFontNameList setHidden:FALSE];
//    [_btnFontNameList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btnFontNameList setBackgroundColor:[UIColor whiteColor]];
//    [_btnFontNameList addTarget:self action:@selector(showFontsList:) forControlEvents:UIControlEventTouchUpInside];
//    
//    thisObj = _btnFontNameList.frame.size;
//    XX = fullWidth - textWidth;
//    YY = lblFontName.frame.origin.y;
//    WW = fullWidth - lblFontName.frame.size.width;
//    HH = labelHeight;
//    [_btnFontNameList setFrame:CGRectMake(XX,YY, WW,HH)];
//    
//    _btnFontNameList.userData = [NSValue valueWithCGPoint:CGPointMake(_btnFontNameList.frame.origin.x+_btnFontNameList.frame.size.width, _btnFontNameList.frame.origin.y)];
//    
//    [self.view addSubview:_btnFontNameList];
    
    //------------EXAMPLE------------------
    [_lblExample setText:@"Text"];
    _lblExample.textAlignment = UITextAlignmentCenter;
    thisObj = _lblExample.frame.size;
    XX = distX_fromLeft;
    YY = topY;
    WW = fullWidth;
    HH = labelHeight;
    [_lblExample setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:_lblExample];
    
    //-------------- FONT SIZE --------------
    _lblFontSize = [[UILabel alloc]init];
    [_lblFontSize setText:@"Size"];
    [_lblFontSize setFont:descrFont];
    
    thisObj = _lblFontSize.frame.size;
    XX = distX_fromLeft;
    YY = _lblExample.frame.origin.y + _lblExample.frame.size.height + distY_line2line+5;
    //YY = topY;
    WW = fullWidth;
    HH = labelHeight;
    [_lblFontSize setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:_lblFontSize];
    
    
    int iMinSize = 10;
    int iMaxSize = 40;
    
    
    [_sldFontSize setMaximumValue:iMaxSize];
    [_sldFontSize setMinimumValue:iMinSize];
    [_sldFontSize setValue:(iMaxSize-iMinSize)/2 animated:TRUE];
    [_sldFontSize addTarget:self action:@selector(didSlideChangeValue) forControlEvents:UIControlEventTouchDragInside];
    
    thisObj = _sldFontSize.frame.size;
    XX = distX_fromLeft;
    YY = _lblFontSize.frame.origin.y + _lblFontSize.frame.size.height + distY_lbl2txt+iMaxSize;
    WW = fullWidth;
    HH = labelHeight/2;
    [_sldFontSize setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:_sldFontSize];
    
    
    UILabel* lblMin = [[UILabel alloc]init];
    [lblMin setText:@"A"];
    [lblMin setFont:[UIFont systemFontOfSize:iMinSize]];
    thisObj = lblMin.frame.size;
    WW = iMinSize;
    HH = iMinSize;
    XX = distX_fromLeft+5;
    YY = _sldFontSize.frame.origin.y -iMinSize;
    [lblMin setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:lblMin];
    
    
    
    UILabel* lblMax = [[UILabel alloc]init];
    [lblMax setText:@"A"];
    [lblMax setFont:[UIFont systemFontOfSize:iMaxSize]];
    thisObj = lblMax.frame.size;
    WW = iMaxSize;
    HH = iMaxSize;
    XX = fullWidth - iMaxSize;
    YY = _sldFontSize.frame.origin.y - iMaxSize;
    [lblMax setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:lblMax];
    
    
    //--------------- FONT TYPE --------------
    
    UILabel* lblFontType = [[UILabel alloc]init];
    [lblFontType setText:@"Type"];
    // [lblFontType setMinimumScaleFactor:.7f];
    [lblFontType setFont:descrFont];
    
    thisObj = lblFontType.frame.size;
    XX = distX_fromLeft;
    YY = _sldFontSize.frame.origin.y + _sldFontSize.frame.size.height + distY_line2line+20;
    WW = labelWidth/2;
    HH = labelHeight;
    [lblFontType setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:lblFontType];
    
    //todo - action for segmButton
    NSArray* arrayItems4SegmButton = [[NSArray alloc]initWithObjects:@"Regular",@"Bold",@"Italic", nil];
    _segmButton = [[UISegmentedControl alloc]initWithItems:arrayItems4SegmButton];
    [_segmButton setSelectedSegmentIndex:0];
    [_segmButton addTarget:self action:@selector(didSelectFontType) forControlEvents:UIControlEventValueChanged];
    
    thisObj = _segmButton.frame.size;
    XX =fullWidth - thisObj.width;
    YY = lblFontType.frame.origin.y;
    WW = thisObj.width;
    HH = thisObj.height;
    [_segmButton setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:_segmButton];
    
    //---------------- FONT COLOR ---------------
    
    UILabel* lblFontColor = [[UILabel alloc]init];
    [lblFontColor setText:@"Color"];
    [lblFontColor setFont:descrFont];
    
    thisObj = lblFontColor.frame.size;
    XX = distX_fromLeft;
    YY = lblFontType.frame.origin.y + lblFontType.frame.size.height + distY_line2line;
    WW = textWidth;
    HH = textHeight;
    
    [lblFontColor setFrame:CGRectMake(XX,YY,WW,HH)];
    [self.view addSubview:lblFontColor];
    
    // todo - module "showFontColor" for fontcolor
    
    
    [_btnFontColor addTarget:self action:@selector(showColor) forControlEvents:UIControlEventTouchUpInside];
   
    if (currentFontColor != nil)
        [_btnFontColor setBackgroundColor:currentFontColor];
    else
        [_btnFontColor setBackgroundColor:CELLDEFAULTFONTCOLOR];
    
    
    thisObj = _btnFontColor.frame.size;
    XX = fullWidth - btnColor.width;
    YY = lblFontColor.frame.origin.y;
    WW = btnColor.width;
    HH = btnColor.height;
    
    
    [_btnFontColor setFrame:CGRectMake(XX,YY,WW,HH)];
    _btnFontColor.userData = [NSValue valueWithCGPoint:CGPointMake(_btnFontColor.frame.origin.x+_btnFontColor.frame.size.width, _btnFontColor.frame.origin.y)];
    [self.view addSubview:_btnFontColor];
    
}

-(void)updateFields
{
   // [_btnFontNameList setTitle:_splitView.cellEditProperties.cellFont.fontName forState:UIControlStateNormal];
    [_btnFontNameList setTitle:CELLDEFAULTFONT.fontName forState:UIControlStateNormal];
    [_sldFontSize setValue:_splitView.cellEditProperties.cellFontSize animated:YES];
    [_segmButton setSelectedSegmentIndex:_splitView.cellEditProperties.cellFontType];
    [_btnFontColor setBackgroundColor:_splitView.cellEditProperties.cellFontColor];
    [_lblExample setFont:[UIFont fontWithName:CELLDEFAULTFONT.fontName size:_splitView.cellEditProperties.cellFontSize]];
    [_lblExample setTextColor:_splitView.cellEditProperties.cellFontColor];
    [_lblFontSize setText:[NSString stringWithFormat:@"Size - %d",(int)_splitView.cellEditProperties.cellFontSize]];
    //set lblExample type
    [self didSelectFontType];
    
}


-(void)showFontsList:(CustomButton_class*)sender
{
    NSLog(@"show List of Fonts+SearchBar");

      
    ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
    controller.showImages = FALSE;
    controller.showBoards = FALSE;
    controller.showAddSymbol = FALSE;
    controller.showFontsList =TRUE;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)didSlideChangeValue
{
    [_lblFontSize setText:[NSString stringWithFormat:@"Size - %d",(int)_sldFontSize.value]];
    _splitView.tempCellProperties.cellFontSize =_sldFontSize.value;
    [_lblExample setFont:[UIFont fontWithName:CELLDEFAULTFONT.fontName size:_sldFontSize.value]];
    
    
}

-(void)didSelectFontType
{
    UIFontDescriptor* fontD ;
    switch (_segmButton.selectedSegmentIndex)  {
        case 0:
             _splitView.tempCellProperties.cellFontType = 0;
            fontD = [UIFontDescriptor fontDescriptorWithName:CELLDEFAULTFONT.fontName size:_splitView.tempCellProperties.cellFontSize];
            break;
        case 1:
             _splitView.tempCellProperties.cellFontType = 1;
            fontD =  [CELLDEFAULTFONT.fontDescriptor fontDescriptorWithSymbolicTraits: UIFontDescriptorTraitBold];
            break;
        case 2:
             _splitView.tempCellProperties.cellFontType = 2;
            fontD = [CELLDEFAULTFONT.fontDescriptor fontDescriptorWithSymbolicTraits: UIFontDescriptorTraitItalic];
            break;
        default:
            _splitView.tempCellProperties.cellFont = [UIFont fontWithName:CELLDEFAULTFONT.fontName size:_splitView.tempCellProperties.cellFontSize];
            break;
    }
    [_lblExample setFont:[UIFont fontWithDescriptor:fontD size:_splitView.tempCellProperties.cellFontSize]];
    
}

-(void)showColor
{
    
    NSLog(@"show colors dialogbox");
    
    
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];//WithNibName:nil bundle:nil];
    controller.delegate = (id)self;
    controller.title = @"Font Color";
    
    [self.navigationController showViewController:controller sender:self];
    
}
#pragma mark NOTIFICATIONS

-(void)notificationUserDidSelectFontFromList:(NSNotification*)notificationParam
{
    NSLog(@"user selected font from list");
    // [self.popover dismissPopoverAnimated:TRUE];
    
    NSString* fontFromList = (NSString*)notificationParam.object;
    if (fontFromList != nil) {
        
        //update image in cell
        [_btnFontNameList setTitle:fontFromList forState:UIControlStateNormal];
        _splitView.tempCellProperties.cellFont = [UIFont fontWithName:fontFromList size:_splitView.tempCellProperties.cellFontSize];
                                                  //fontNamesForFamilyName:fontFromList];
        
    }
    else{
        NSLog(@"notificationUserDidSelectImageFromList - can't find image path");
        //imgFromUserChoice=[UIImage imageNamed:@"myvoice.jpg"];
    }
    
}

#pragma mark DELEGATES

#pragma mark colorPicker

- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didSelectColor:(UIColor *)color
{
    _splitView.tempCellProperties.cellFontColor = color;
    [_btnFontColor setBackgroundColor:color];
    [_lblExample setTextColor:color];

    [self.navigationController popToRootViewControllerAnimated:TRUE];
}
- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller
{
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}
@end

