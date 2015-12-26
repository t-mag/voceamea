//
//  PopupMenu_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 22/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

//#import "PopupMenu_viewcontroller.h"
//#import "Camera_viewcontroller.h"
#import "CellOptions_viewcontroller.h"
#import "STCollapseTableView.h"
#import "Popupmenu_class.h"
#import "PopupMenu_tableviewcell.h"
#import "NEOColorPickerViewController.h"


@interface PopupMenu_viewcontroller () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate>

@property NSArray* arrayOfMenuHeaders;
@property NSMutableArray* arrayOfMenuItems4Symbol;
@property NSMutableArray* arrayOfMenuItems4Sound;
@property NSMutableArray* arrayOfMenuItems4Color;
@property NSMutableArray* arrayOfMenuItems4Links;
@property UIImagePickerController* picker;


@property CellOptions_viewcontroller* celloptionsVC;
//@property PopupMenu_tableviewcell* selectedCell;




@end


@implementation PopupMenu_viewcontroller
@synthesize tblPopupMenu,iTypeOfPopup;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // set size for popup window
    self.preferredContentSize = CGSizeMake(320, 350);
    
    
    // set the correct menu according to user choice
    iTypeOfPopup=1;

    //set listner for Notification
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(notificationUserDidSelectImage:) name:@"dismisspopupmenu" object:nil];
    [notificationCenter addObserver:self selector:@selector(notificationGetPoint4Popup:) name:@"point4popup" object:nil];
    
    
    [self initMenus];
    
    [tblPopupMenu setDelegate:self];
    [tblPopupMenu setDataSource:self];
    
    [tblPopupMenu openSection:0 animated:YES];
    tblPopupMenu.shouldHandleHeadersTap=YES;
    
    [tblPopupMenu reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)notificationUserDidSelectImage:(NSNotification*) notification
{
    NSLog(@"popup menu image received");
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)notificationGetPoint4Popup:(NSNotification*) notification
{
   // NSValue *valPoint4Popup = notification.object;
   // _pointOfRef4ShowPopup = valPoint4Popup.CGPointValue;
    
}

#pragma -
#pragma mark TableView
#pragma mark UITableViewDataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _arrayOfMenuItems4Symbol.count;
            break;
        case 1:
            return _arrayOfMenuItems4Sound.count;
            break;
        case 2:
            return _arrayOfMenuItems4Color.count;
            break;
        case 3:
            return _arrayOfMenuItems4Links.count;
            break;

            
        default:
            return 1;
            break;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* currCell = [tblPopupMenu dequeueReusableCellWithIdentifier:@"basic" forIndexPath:indexPath];
   
    Popupmenu_class* itemX = [[Popupmenu_class alloc]init];
    
    switch (indexPath.section) {
        case 0: //SYMBOLS
           itemX = [_arrayOfMenuItems4Symbol objectAtIndex:indexPath.row];
         //  [currCell.imgMenuItem setImage:itemX.mnuItemImage];
         //  [currCell.lblMenuItem setText:itemX.mnuItemText];
            [currCell.textLabel setText:itemX.mnuItemText];
            return  currCell;
            break;
       
        case 1: //SOUND
            itemX = [_arrayOfMenuItems4Sound objectAtIndex:indexPath.row];
            [currCell.textLabel setText:itemX.mnuItemText];
            return  currCell;
            break;
            
        case 2: //COLOR
            itemX = [_arrayOfMenuItems4Color objectAtIndex:indexPath.row];
           // [currCell.imgMenuItem setImage:itemX.mnuItemImage];
           // [currCell.lblMenuItem setText:itemX.mnuItemText];
             [currCell.textLabel setText:itemX.mnuItemText];
            return  currCell;
            break;
            
        case 3: //Links
            itemX = [_arrayOfMenuItems4Links objectAtIndex:indexPath.row];
            // [currCell.imgMenuItem setImage:itemX.mnuItemImage];
            // [currCell.lblMenuItem setText:itemX.mnuItemText];
            [currCell.textLabel setText:itemX.mnuItemText];
            return  currCell;
            break;

            
        default:
           // [currCell.imgMenuItem setImage:nil];
           // [currCell.lblMenuItem setText:@"NULL"];
             [currCell.textLabel setText:@"NULL"];
            return  currCell;

            break;
    }
    
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: //Symbol
            if (indexPath.row == 0) {
              
                //send notification - show imeduatly the list
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowListOfImages" object:nil];
            }
            if (indexPath.row == 1) {
                
                //send notification - show the camera
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowCamera" object:nil];

                
            }
            if (indexPath.row == 2) {
                

                //send notification - show the photos library
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowPhotosLibrary" object:nil];
            }
            if (indexPath.row == 3) { //Remove image
                
                //send notification - remove the image from cell
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"removeImageFromCell" object:nil];

                
            }

            break;
            
        case 1: //Sound
            //
            if (indexPath.row == 0) {// new recording
                
                //send notification
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowVoiceRecorder" object:nil];
            }
            
            if (indexPath.row == 1) { //remove recording
                
                //send notification
              //  NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
               // [notificationcenter postNotificationName:@"doShowVoiceRecorder" object:nil];
            }
            
            
            break;
            
        case 2: //Colors
            // Backgound
            if (indexPath.row == 0) {
                
                //send notification
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowColors4Background" object:nil];
            }
            
            // Frame
            if (indexPath.row == 1) {
                
                
                //send notification
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowColors4Frame" object:nil];
                
            }

            break;
            
        case 3: //Links
            
            // Board
            if (indexPath.row == 0) {
                
                //send notification - show imediatley the list
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowListOfExistingBoards" object:nil];
            }
            
            // Sound/Music
            if (indexPath.row == 1) {
                
                //send notification - show imediatley the list
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowListOfExistingSounds" object:nil];
            }

            //Videos
            if (indexPath.row == 2) {
                
                //send notification - show imediatley the list
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowListOfExistingVideos" object:nil];
            }

            //WEb
            if (indexPath.row == 3) {
                
                //send notification - show imediatley the list
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doShowWebBrowser" object:nil];
            }

            //Remove link
            if (indexPath.row == 4) {
                
                //send notification - show imediatley the list
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"doRemoveExistingLink" object:nil];
            }


     
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float width = tableView.bounds.size.width;
    int fontSize = 18;
    int padding = 10;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, fontSize)];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    view.userInteractionEnabled = YES;
    view.tag = section;
    
    if (section==0)
    {
        UIImageView *image = [[UIImageView alloc]init];
        [image setImage:[UIImage imageNamed:@"pic_icon.png"]];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview: image];
        padding = image.frame.size.width+10;
    }
    
    if (section==1)
    {
        UIImageView *image1 = [[UIImageView alloc]init];
        [image1 setImage:[UIImage imageNamed:@"snd_icon.png"]];
        image1.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview: image1];
        padding = image1.frame.size.width+10;
    }
    
    if (section==2)
    {
        UIImageView *image2 = [[UIImageView alloc]init];

        [image2 setImage:[UIImage imageNamed:@"color_icon.png"]];
        image2.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview: image2];
        padding = image2.frame.size.width+10;
    }
    
    if (section==3)
    {
        UIImageView *image3 = [[UIImageView alloc]init];
        
        [image3 setImage:[UIImage imageNamed:@"color_icon.png"]];
        image3.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview: image3];
        padding = image3.frame.size.width+10;
    }

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, 2, width - padding, fontSize)];
    if (section==0) label.text = @"Symbol";
    if (section==1) label.text = @"Sound";
    if (section==2) label.text = @"Color";
    if (section==3) label.text = @"Link";
    
    //label.text = @"Texto";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(0,1);
    label.font = [UIFont fontWithName:@"Times New Roman" size:fontSize];
    
    [view addSubview:label];
    
    return view;
}



#pragma ===================

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//}

#pragma Custom Funcs
#pragma -

-(void)initMenus
{
    
    _arrayOfMenuItems4Symbol = [[NSMutableArray alloc]init];
    
    Popupmenu_class* mnuSYMItem = [[Popupmenu_class alloc]init];
    mnuSYMItem.mnuItemText = @"List";
    mnuSYMItem.mnuItemImage = [UIImage imageNamed:@"combobox_48x48.gif"];
    [_arrayOfMenuItems4Symbol addObject:mnuSYMItem];
    
    Popupmenu_class* mnuSYMItem1 = [[Popupmenu_class alloc]init];
    mnuSYMItem1.mnuItemText = @"Camera";
    mnuSYMItem1.mnuItemImage = [UIImage imageNamed:@"camera5.png"];
    [_arrayOfMenuItems4Symbol addObject:mnuSYMItem1];

    Popupmenu_class* mnuSYMItem2 = [[Popupmenu_class alloc]init];
    mnuSYMItem2.mnuItemText = @"Photoes";
    mnuSYMItem2.mnuItemImage = [UIImage imageNamed:@"picture.png"];
    [_arrayOfMenuItems4Symbol addObject:mnuSYMItem2];
    
    Popupmenu_class* mnuSYMItem3 = [[Popupmenu_class alloc]init];
    mnuSYMItem3.mnuItemText = @"Remove";
    mnuSYMItem3.mnuItemImage = [UIImage imageNamed:@"trash_bin.png"];
    [_arrayOfMenuItems4Symbol addObject:mnuSYMItem3];
    

    //-------------------------------------------
    
    _arrayOfMenuItems4Sound = [[NSMutableArray alloc]init];
    
    Popupmenu_class* mnuSNDItem = [[Popupmenu_class alloc]init];
    mnuSNDItem.mnuItemText = @"New recording";
    mnuSNDItem.mnuItemImage = [UIImage imageNamed:@"microphone.png"];
    [_arrayOfMenuItems4Sound addObject:mnuSNDItem];
    
    Popupmenu_class* mnuSNDItem1 = [[Popupmenu_class alloc]init];
    mnuSNDItem1.mnuItemText = @"Remove";
    mnuSNDItem1.mnuItemImage = [UIImage imageNamed:@"trash_bin.png"];
    [_arrayOfMenuItems4Sound addObject:mnuSNDItem1];
    
    //-------------------------------------------
    
    _arrayOfMenuItems4Color = [[NSMutableArray alloc]init];
    
    Popupmenu_class* mnuColorItem = [[Popupmenu_class alloc]init];
    mnuColorItem.mnuItemText = @"Background";
    mnuColorItem.mnuItemImage = [UIImage imageNamed:@"frames_backcolor.png"];
    [_arrayOfMenuItems4Color addObject:mnuColorItem];
    
    Popupmenu_class* mnuColorItem1 = [[Popupmenu_class alloc]init];
    mnuColorItem1.mnuItemText = @"Frame";
    mnuColorItem1.mnuItemImage = [UIImage imageNamed:@"pic_frame.png"];
    [_arrayOfMenuItems4Color addObject:mnuColorItem1];
    

    //-------------------------------------------
    
    _arrayOfMenuItems4Links = [[NSMutableArray alloc]init];
    
    Popupmenu_class* mnuLNKItem1 = [[Popupmenu_class alloc]init];
    mnuLNKItem1.mnuItemText = @"Board";
    mnuLNKItem1.mnuItemImage = [UIImage imageNamed:@"globe.png"];
    [_arrayOfMenuItems4Links addObject:mnuLNKItem1];
    
    Popupmenu_class* mnuLNKItem2 = [[Popupmenu_class alloc]init];
    mnuLNKItem2.mnuItemText = @"Sound";
    mnuLNKItem2.mnuItemImage = [UIImage imageNamed:@"globe.png"];
    [_arrayOfMenuItems4Links addObject:mnuLNKItem2];
    
    Popupmenu_class* mnuLNKItem3 = [[Popupmenu_class alloc]init];
    mnuLNKItem3.mnuItemText = @"Video";
    mnuLNKItem3.mnuItemImage = [UIImage imageNamed:@"globe.png"];
    [_arrayOfMenuItems4Links addObject:mnuLNKItem3];
    
    Popupmenu_class* mnuLNKItem4 = [[Popupmenu_class alloc]init];
    mnuLNKItem4.mnuItemText = @"Web";
    mnuLNKItem4.mnuItemImage = [UIImage imageNamed:@"globe.png"];
    [_arrayOfMenuItems4Links addObject:mnuLNKItem4];
    
    Popupmenu_class* mnuLNKItem5 = [[Popupmenu_class alloc]init];
    mnuLNKItem5.mnuItemText = @"Remove";
    mnuLNKItem5.mnuItemImage = [UIImage imageNamed:@"globe.png"];
    [_arrayOfMenuItems4Links addObject:mnuLNKItem5];

    
    _arrayOfMenuHeaders = [[NSArray alloc]initWithObjects:@"Symbol",@"Sound",@"Color",@"Link", nil];
    

}


-(void)showCameraPicker
{
    NSLog(@"showCamera-CAMERA");
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    
    _picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    _picker.allowsEditing = YES;
    _picker.sourceType = type;
    [self presentViewController:_picker animated:YES completion:nil];
    
}

-(void)showPhotoes
{
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    _picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    _picker.allowsEditing = YES;
    _picker.sourceType = type;
    [self presentViewController:_picker animated:YES completion:nil];
    
}


//-(void)CellOptionsDidReturnWithImage:(UIImage *)image
//{
//    if (image) {
//     //   [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }else{
//        
//    }
//    
//}

@end
