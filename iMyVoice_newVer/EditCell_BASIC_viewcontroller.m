//
//  EditCell_BASIC_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/13/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import "EditCell_BASIC_viewcontroller.h"
#import "AppDelegate.h"
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "CustomButton_class.h"
#import "ListofObjects_tableviewcontroller.h"
#import "EasyAlertView.h"
#import "Images_class.h"
#import "XMLmanager_class.h"
#import "Images_class.h"
#import "SplitView_manual_viewcontroller.h"

@interface EditCell_BASIC_viewcontroller () <UITextFieldDelegate,UIImagePickerControllerDelegate>
@property GlobalsFunctions_class* globalFuncs;
@property AppDelegate* appDelegate;
@property SplitView_manual_viewcontroller* splitView;
@property CustomButton_class* btnShowImagesList;
@property CustomButton_class* btnShowCamera;
@property CustomButton_class* btnShowPhotoLibrary;



@end

@implementation EditCell_BASIC_viewcontroller
@synthesize lblHideCell,lblMessageInCell,lblTextInCell,lblTextOnTop,txtMessageInCell,txtTextInCell,swtHideCell,swtTextOnTop,btnImageInCell,myParentWidth,myParentHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _globalFuncs = [[GlobalsFunctions_class alloc]init];
    _appDelegate = DELEGATE;
    _splitView = (id)self.parentViewController.parentViewController;
    
    
    [txtTextInCell setDelegate:self];
    [txtMessageInCell setDelegate:self];
   
    
   
 
    
    //notifications
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    //notifications for - reacting to the choice the user made
    [notificationCenter addObserver:self selector:@selector(notificationUserDidSelectImageFromList:) name:@"imagefromlist" object:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setTitle:@"Basic"];
    
}

-(void)viewWillLayoutSubviews
{
    [self re_arangeObjects];
    // update text in cell
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


#pragma mark NOTIFICATIONS
-(void)notificationUserDidSelectImageFromList:(NSNotification*)notificationParam
{
    NSLog(@"user selected image from list");
   // [self.popover dismissPopoverAnimated:TRUE];
    
    Images_class* imgX = (Images_class*)notificationParam.object;
    if (imgX != nil) {
        
        //update image in cell
        _splitView.tempCellProperties.cellImageID = imgX.imgIndex;
       
      
        NSString* imgX_fullFilename = [[LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:imgX.imgPath] stringByAppendingPathComponent:imgX.imgFileName];
        
        [btnImageInCell setImage:[UIImage imageWithContentsOfFile:imgX_fullFilename] forState:UIControlStateNormal];
        
    }
    else{
        NSLog(@"notificationUserDidSelectImageFromList - can't find image path");
        //imgFromUserChoice=[UIImage imageNamed:@"myvoice.jpg"];
    }

}


#pragma mark FUNCTIONS


-(void)re_arangeObjects
{
    
    
    CGRect viewRect = [_globalFuncs getViewSize:self.view];
    
    
    
    // float topBorder = TOOLBARHIGH + 10;
    
    NSLog(@"BASIC - re_arangeObjects");
    float XX,YY,WW,HH;
    CGSize thisObj;
    int fullWidth = self.view.frame.size.width - 20;
    int labelWidth = 200;
    int labelHeight = 30;
    int textWidth = 200;
    int textHeight = 30;
    
    int distY_lbl2txt = 5;
    int distX_fromLeft = 10;
    int distX_lbl2btn = 15;
    int distY_line2line = 15;
    int distX_col2col = 20;
    
    
    UIFont* userFont = [UIFont fontWithName:@"System" size:14];
    UIFont* descrFont = [UIFont fontWithName:@"System" size:12];
    
    
    float topY = self.navigationController.navigationBar.frame.size.height+10;
    
#pragma mark  ------------- TEXT IN CELL -----------------
    
    [lblTextInCell setText:@"Cell Text"];
    [lblTextInCell setFont:descrFont];
    
    
    thisObj = lblTextInCell.frame.size;
    XX = distX_fromLeft;
    YY = topY;
    WW = labelWidth;
    HH = thisObj.height;
    [lblTextInCell setFrame:CGRectMake(XX, YY, WW, HH)];
    
    
    [txtTextInCell setFont:userFont];

    txtTextInCell.textAlignment = NSTextAlignmentCenter;
    thisObj = txtTextInCell.frame.size;
    XX = distX_fromLeft;
    YY = lblTextInCell.frame.origin.y+lblTextInCell.frame.size.height+distY_lbl2txt;
    WW = fullWidth;
    HH = thisObj.height;
    [txtTextInCell setFrame:CGRectMake(XX,YY ,WW ,HH )];
    
#pragma mark ------------ IMAGE BUTTON ------------
    thisObj = btnImageInCell.frame.size;
    XX=distX_fromLeft;
    YY=txtTextInCell.frame.origin.y + txtTextInCell.frame.size.height+distY_line2line;
    WW = thisObj.width;
    HH = thisObj.height;
    [btnImageInCell setFrame:CGRectMake(XX, YY, WW, HH)];
    
    //-------------- Show Images List ------------
    _btnShowImagesList = [[CustomButton_class alloc]init];
    [_btnShowImagesList addTarget:self action:@selector(showImagesList) forControlEvents:UIControlEventTouchUpInside];
    [_btnShowImagesList setTitle:@"Images List" forState:UIControlStateNormal];
    [_btnShowImagesList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    thisObj = _btnShowImagesList.frame.size;
    WW = fullWidth - btnImageInCell.frame.size.width - distX_lbl2btn;
    HH = textHeight;
    XX=btnImageInCell.frame.origin.x + btnImageInCell.frame.size.width + 10;
    YY=btnImageInCell.frame.origin.y;
    
    [_btnShowImagesList setFrame:CGRectMake(XX, YY, WW, HH)];
    
    [self.view addSubview:_btnShowImagesList];
    
    //-------------- Show Camera ------------
    _btnShowCamera = [[CustomButton_class alloc]init];
    [_btnShowCamera addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    [_btnShowCamera setTitle:@"Camera" forState:UIControlStateNormal];
    [_btnShowCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    thisObj = _btnShowCamera.frame.size;
    WW = fullWidth - btnImageInCell.frame.size.width - distX_lbl2btn;
    HH = textHeight;
    XX=btnImageInCell.frame.origin.x + btnImageInCell.frame.size.width + 10;
    YY=_btnShowImagesList.frame.origin.y + _btnShowImagesList.frame.size.height+15;
    
    [_btnShowCamera setFrame:CGRectMake(XX, YY, WW, HH)];
    
    [self.view addSubview:_btnShowCamera];
    
    //-------------- Show Photo Library ------------
    _btnShowPhotoLibrary = [[CustomButton_class alloc]init];
    [_btnShowPhotoLibrary addTarget:self action:@selector(showPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [_btnShowPhotoLibrary setTitle:@"Photo Library" forState:UIControlStateNormal];
    [_btnShowPhotoLibrary setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    thisObj = _btnShowPhotoLibrary.frame.size;
    WW = fullWidth - btnImageInCell.frame.size.width - distX_lbl2btn;
    HH = textHeight;
    XX= btnImageInCell.frame.origin.x + btnImageInCell.frame.size.width + 10;
    YY=_btnShowCamera.frame.origin.y + _btnShowCamera.frame.size.height+15;
    
    [_btnShowPhotoLibrary setFrame:CGRectMake(XX, YY, WW, HH)];
    
    [self.view addSubview:_btnShowPhotoLibrary];
    
    //todo - on press open popover view
    
#pragma mark ------------- MESSAGE IN CELL --------------
    
    [lblMessageInCell setText:@"Message Text"];
    [lblMessageInCell setFont:descrFont];
    
    
    thisObj = lblMessageInCell.frame.size;
    XX=txtTextInCell.frame.origin.x;
    YY=btnImageInCell.frame.origin.y + btnImageInCell.frame.size.height+distY_line2line;;
    WW = labelWidth;
    HH = thisObj.height;
    [lblMessageInCell setFrame:CGRectMake(XX, YY, WW, HH)];
    
    
    [txtMessageInCell setFont:userFont];
    txtMessageInCell.textAlignment = NSTextAlignmentCenter;
    thisObj = txtMessageInCell.frame.size;
    XX=lblMessageInCell.frame.origin.x;
    YY=lblMessageInCell.frame.origin.y + lblMessageInCell.frame.size.height + distY_lbl2txt;
    WW = fullWidth;
    HH = thisObj.height;
    [txtMessageInCell setFrame:CGRectMake(XX,YY, WW,HH)];
    
    
    CGSize btnMSGsize = CGSizeMake(50, 50);
    
    //------------- TEXT PLACE --------------------
    
    [lblTextOnTop setText:@"Text on Top"];
    //[lblTextOnTop setMinimumScaleFactor:.7f];
    
    thisObj = lblTextOnTop.frame.size;
    
    XX = txtTextInCell.frame.origin.x;
    YY = txtMessageInCell.frame.origin.y + txtMessageInCell.frame.size.height + distY_line2line;
    WW = labelWidth; //   fullWidth - swtTextOnTop.frame.size.width-5;
    HH = thisObj.height;
    [lblTextOnTop setFrame:CGRectMake(XX,YY, WW,HH)];
    
    
    [swtTextOnTop setOn:FALSE];
    thisObj = swtTextOnTop.frame.size;
    XX = fullWidth - thisObj.width ;
    YY = lblTextOnTop.frame.origin.y;
    WW = thisObj.width;
    HH = thisObj.height;
    [swtTextOnTop setFrame:CGRectMake(XX,YY, WW,HH)];
    [swtTextOnTop addTarget:self action:@selector(swtTextOnTop_didChanged) forControlEvents:UIControlEventValueChanged];
    
    
    // ------------- HIDE CELL ---------------------
    
    thisObj = lblHideCell.frame.size;
    
    XX = lblTextOnTop.frame.origin.x ;
    YY = lblTextOnTop.frame.origin.y + lblTextOnTop.frame.size.height + distY_line2line+10;
    WW = labelWidth;
    HH = thisObj.height;
    [lblHideCell setFrame:CGRectMake(XX,YY, WW,HH)];
    
    
    thisObj = swtHideCell.frame.size;
    XX = fullWidth - thisObj.width;
    YY = lblHideCell.frame.origin.y ;
    WW = thisObj.width;
    HH = thisObj.height;
    [swtHideCell setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [swtHideCell addTarget:self action:@selector(swtHideCell_didChanged) forControlEvents:UIControlEventValueChanged];
    
    
}

- (IBAction)btnImageAction:(UIButton *)sender {
    
    
    
}



-(void)showImagesList
{
    NSLog(@"show List of Images+SearchBar");
    
    
    
    ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
    controller.showImages = TRUE;
  //  controller.isSearching = TRUE;
  //  controller.searchItem = txtTextInCell.text;
    controller.showBoards = FALSE;
    controller.showAddSymbol = FALSE;
    
    [self.navigationController pushViewController:controller animated:TRUE];
}

-(void)showCamera
{
    NSLog(@"show camera");
    
    //    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    //    [notificationcenter postNotificationName:@"dismisspopover" object:nil];
    
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:(id)self];
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    controller.sourceType = type;
    controller.showsCameraControls = YES;
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    controller.view.superview.frame = CGRectMake(0, 0, 540, 620); //it's important to do this after presentModalViewController
    
    UIPopoverController* popupVC = [[UIPopoverController alloc]initWithContentViewController:controller];
    [popupVC presentPopoverFromRect:CGRectMake(4,5, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:TRUE];
    
    
}

-(void)showPhotoLibrary
{
    NSLog(@"show photos library");
    //    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    //    [notificationcenter postNotificationName:@"dismisspopover" object:nil];
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:(id)self];
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.sourceType = type;
    controller.allowsEditing = YES;
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    controller.view.superview.frame = CGRectMake(0, 0, 400, 350); //it's important to do this after presentModalViewController
    
    UIPopoverController* popupVC = [[UIPopoverController alloc]initWithContentViewController:controller];
    [popupVC presentPopoverFromRect:CGRectMake(4,5, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:TRUE];
}

-(void)add_image2XMLfile
{
    XMLmanager_class* xmlHandler = [[XMLmanager_class alloc]init];
    [xmlHandler createImagesLocalXMLfile:@"new image from camera" andwith:[_appDelegate arrayOfImages]];
}

-(void)updateFields
{
    txtTextInCell.text = _splitView.cellEditProperties.cellText;
    txtMessageInCell.text = _splitView.cellEditProperties.cellMessage;
    
    //image
    Images_class* imgX;
    for (imgX in _appDelegate.arrayOfImages)
    {
        if (imgX.imgIndex == _splitView.cellEditProperties.cellImageID) {
            break;
        }
    }
    
    if (imgX != nil) {
       
        NSString* imgX_fullFilename = [[LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:imgX.imgPath] stringByAppendingPathComponent:imgX.imgFileName];
        
        [btnImageInCell setImage:[UIImage imageWithContentsOfFile:imgX_fullFilename] forState:UIControlStateNormal];
        
    }
    else{
        
        NSLog(@"spliview cell edit - can't find image path");
    }
  
    //------------------
    
    [swtHideCell setOn:_splitView.cellEditProperties.cellHidden animated:(YES)];
    [swtTextOnTop setOn:_splitView.cellEditProperties.cellTextOnTop animated:YES];
    
    
}

-(void)swtTextOnTop_didChanged
{
    _splitView.tempCellProperties.cellTextOnTop = swtTextOnTop.on;
}

-(void)swtHideCell_didChanged
{
    _splitView.tempCellProperties.cellHidden = swtHideCell.on;
}

#pragma mark -
#pragma mark DELEGATES

#pragma mark -
#pragma mark TEXTFIELD

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [txtMessageInCell setText:textField.text];
    _splitView.tempCellProperties.cellText = txtTextInCell.text;
    _splitView.tempCellProperties.cellMessage = txtMessageInCell.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [txtMessageInCell setText:textField.text];
    _splitView.tempCellProperties.cellText = txtTextInCell.text;
    _splitView.tempCellProperties.cellMessage = txtMessageInCell.text;
    [txtTextInCell resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark ImagePickerViewController


//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)
//{
//
//}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    // if image comes from album don't save it again
    // UIImagePickerControllerReferenceURL IS nil when image comes from camera
    if ( [info valueForKey:UIImagePickerControllerReferenceURL] == nil)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
    }
    
    UIImage* resizedImage = [_globalFuncs resizeImage:image];
    
    Images_class* imgX = [[Images_class alloc]init];
    
    [EasyAlertView showWithTitle:IMAGESAVE_ALERT_TITLE message:@"Save image as ..." alertStyle:UIAlertViewStylePlainTextInput usingBlock:^(NSUInteger buttonIndex, NSMutableArray* inpText)
     {
         if (buttonIndex == 0) {
             NSString* strImageName = [inpText objectAtIndex:0];
             
             int iIndex = (int)[_appDelegate iTotalUserImages] +1;
             NSString* strSaveName = [[NSString stringWithFormat:@"%@%d",PREFIX_USER_IMAGES,iIndex] stringByAppendingPathExtension:@"png"];
             
             NSData* data = UIImagePNGRepresentation(resizedImage);
             
             NSString* imagePath = [[LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:SYMBOLS_FOLDER_FROM_USER] stringByAppendingPathComponent:strSaveName];
             
             NSError* error;
             NSFileManager* filemanager = [NSFileManager defaultManager];
             
             NSString* dirUser = [LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:SYMBOLS_FOLDER_FROM_USER] ;
             
             
             [filemanager createDirectoryAtPath:dirUser withIntermediateDirectories:YES attributes:nil error:&error];
             
             [data writeToFile:imagePath atomically:YES];
             
              BOOL res = [imgX updateImageClasswithShowName:strImageName
                                        andwithDescription:@"camera"
                                           andwithFileName:strSaveName
                                               andwithPath:SYMBOLS_FOLDER_FROM_USER
                                           andwithCategory:@"general"
                                        andwithUpdatedDate:[NSDate date]
                                      andwithUpdatedDateby:@"admin"
                                             andwithPrompt:@""
                                               andwithType:@""
                                              andwithIndex:[strSaveName stringByDeletingPathExtension]];
             
             
             
             if (!res) {
                 NSLog(@"Couldn't update image from camera");
             }
             else
             {
                 _splitView.tempCellProperties.cellImageID = imgX.imgIndex;
                 //add new image from camera to arrayOfImages
                 [_appDelegate.arrayOfImages addObject:imgX];
                 
                 //update total num of images from user
                 _appDelegate.iTotalUserImages= iIndex;
                 
                 // //add the new image from camera to the xml file in background
                 [self performSelectorInBackground:@selector(add_image2XMLfile) withObject:nil];
                 
                 //anounce that image has been capture
                 NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                 [notificationcenter postNotificationName:@"imageFromCamera" object:imgX];
                 
             }
         }
     }
     
               cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
    
    
    [btnImageInCell setImage:resizedImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
@end
