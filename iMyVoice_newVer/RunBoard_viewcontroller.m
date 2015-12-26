//
//  RunBoard_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 10/10/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import <AVFoundation/AVSpeechSynthesis.h>
#import "Text2Speech.h"
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "RunBoard_viewcontroller.h"
#import "RunBoardCell_collectionviewcell.h"
#import "AppDelegate.h"
#import "Board_class.h"
#import "Cell_class.h"
#import "BoardsList_class.h"
#import "Images_class.h"
#import "GlobalsFunctions_class.h"
#import "Globals.h"
#import "EasyAlertView.h"
#import "RFQuiltLayout.h"
#import "XMLmanager_class.h"





@interface RunBoard_viewcontroller () <RFQuiltLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,AVSpeechSynthesizerDelegate,UIPopoverControllerDelegate >

@property AppDelegate* appDelegate;
@property AVAudioPlayer *audioPlayer;
@property NSMutableArray* matrixOfCells;
@property NSMutableArray* arrayOfCells;
@property Cell_class* cellSelectedbyUser;
//@property RunBoardCell_collectionviewcell* currCellSelectedbyUser;
@property GlobalsFunctions_class* globalFuncs;


@end

@implementation RunBoard_viewcontroller
@synthesize colRunBoard;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"RunBoard - viewDidLoad");
    _audioPlayer = [[AVAudioPlayer alloc]init];
    _globalFuncs = [[GlobalsFunctions_class alloc]init];
    _arrayOfCells = [[NSMutableArray alloc]init];
    _matrixOfCells = [[NSMutableArray alloc]init];
    
    _cellSelectedbyUser = [[Cell_class alloc]init];
    colRunBoard.delegate = self;
    colRunBoard.dataSource = self;
    _appDelegate = DELEGATE;
    
    CGSize screenSize = [_globalFuncs calcWorkScreenSize];
    [colRunBoard setFrame:CGRectMake(1, 1, screenSize.width, screenSize.height)];
    
    RFQuiltLayout* layout = (id)[colRunBoard collectionViewLayout];
    [layout setDelegate:self];
    [layout setDirection: UICollectionViewScrollDirectionVertical];
    layout.blockPixels=[_globalFuncs calcCellSizewith_CollectionViewSize:colRunBoard.frame.size];
    layout.prelayoutEverything=TRUE;
    
    
    [self initBoard2];
   
    [colRunBoard reloadData];


}

-(void)viewWillAppear:(BOOL)animated
{
     NSLog(@"RunBoard - viewWillAppear");
    
//    -(void)notificationUserDidSelectBoardFromList : (NSNotification*) notification
//    {
//        NSLog(@"show loaded board");
//        [self.popover dismissPopoverAnimated:TRUE];
        NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
        [notificationcenter postNotificationName:@"dismisspopover" object:@"notificationUserDidSelectBoardFromList"];
    
        BoardsList_class* board4Loading = _appDelegate.HomepageBoard;//    (BoardsList_class*)notification.object;
        XMLmanager_class* xmlFuncs = [[XMLmanager_class alloc]init];
        
        
        
        //retrieve the board from the array. the board will ALWAYS sit at index 0
        [xmlFuncs loadBoardData:board4Loading];
    
    [_arrayOfCells removeAllObjects];
    [_matrixOfCells removeAllObjects];
    
    NSMutableArray* arrayTMP = [[NSMutableArray alloc]init];
    for (int i=1; i<[[_appDelegate arrayOfLoadedBoard] count]; i++) {
        [arrayTMP addObject:[[_appDelegate arrayOfLoadedBoard] objectAtIndex:i]];
    }
    
    _matrixOfCells = [arrayTMP mutableCopy];
    
    
    for (int i=0; i<_matrixOfCells.count; i++)
    {
        NSMutableArray* arrayTMP = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
        for (int j=0; j<arrayTMP.count; j++ ) {
            Cell_class* cellFromData = [[Cell_class alloc]init];
            cellFromData = [arrayTMP objectAtIndex:j];
            
            if (cellFromData.mark4show)
                [_arrayOfCells addObject:cellFromData];
        }
    }
    
   [_globalFuncs PrintOut_matrix:_matrixOfCells showIndex:NO showMark:YES];
   
    [colRunBoard reloadData];


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


#pragma mark -
#pragma mark CollectionView

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayOfCells.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"collDataSource - load cells with classCell");
    
    RunBoardCell_collectionviewcell* currCell;
    currCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"customruncell" forIndexPath:indexPath];
    //currCell.delegate=self;
    Cell_class* currCell_class = [_arrayOfCells objectAtIndex:indexPath.row];
    
    // update grid's cell with text
    NSString* str = currCell_class.cellText;
    [currCell.lblText setText:str];
    
    
    
    // update grid's cell with image
    
    // search for the image in arrayOfImages and retrieve its info
    Images_class* currImage = [[Images_class alloc]init];
    BOOL flgFileExists = NO;
    if ([currCell_class.cellImageID integerValue] > -1 && currCell_class.cellImageID != nil) {
        for (int i=0;i<_appDelegate.arrayOfImages.count; i++) {
            Images_class* imgX = [_appDelegate.arrayOfImages objectAtIndex:i];
            
            if ([imgX.imgIndex isEqualToString:currCell_class.cellImageID]) {
                NSLog(@"RunBoard_viewcontroller - found the image in array");
                flgFileExists=YES;
                currImage = imgX;
                i =[[NSNumber numberWithLong:[_appDelegate.arrayOfImages count]] intValue];
            }
        }
    }
    
    // if file exists - update it
    if (flgFileExists) {
        NSString* imgFullFilename = [_globalFuncs getFullDirectoryPathfor:currImage.imgPath];
        imgFullFilename = [imgFullFilename stringByAppendingPathComponent:currImage.imgFileName];
        
        UIImage* imgX = [UIImage imageWithContentsOfFile:imgFullFilename];
        currCell.imgSymbol.image = imgX;
    }
    else // file not exisitng  OR user choosed to remove it
    {
        currCell.imgSymbol.image = nil;
    }
    
    currCell.contentView.layer.cornerRadius=20;
    
    [currCell.contentView.layer setBorderWidth:5.0f];
    
    [currCell.contentView setBackgroundColor:currCell_class.cellBackgroundColor];
    [currCell.contentView.layer setBorderColor:[currCell_class.cellBorderColor CGColor]];
    
    [self rearange_objectsInCell:currCell];
    
    
    return currCell;
}


//-(void)userDidTapOnCell:(UITapGestureRecognizer *)recognizer
//{
//
//
////
////    EditBoard_viewcontroller* didTapCell = [[EditBoard_viewcontroller alloc]init];
////    didTapCell= recognizer.self;
////
////
////    //if code entered this function, it means the user tapped 1 times (once)
////  //  NSIndexPath *indexPath = [_colEditBoard indexPathForCell:didTapCell.col];
////    _cellSelectedbyUser = _arrayOfCells[indexPath.row];
////
////
////    UIAlertView* inpBox = [[UIAlertView alloc]initWithTitle:TEXT_ALERT_TITLE message:@"Enter new text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
////    inpBox.alertViewStyle = UIAlertViewStylePlainTextInput;
////    [inpBox show];
//
//
//}

//-(void)userDidPressLongOnCell
//{
//    //if code entered this function, it means the user tapped 2 times (twice)
//
//    // popupmenuPopoverController is declared as UIPopOverController
//    if ([self.popover isPopoverVisible]) {
//        [self.popover dismissPopoverAnimated:YES];
//    }
//    else
//    {
//
//        NSError* error;
////        NSIndexPath *indexPath = [_colEditBoard indexPathForCell:cell];
////        _cellSelectedbyUser = _arrayOfCells[indexPath.row];
//
//        //todo - create a list of choices if the cell contains also link to MP3 or VIDEO or WEB
//        if (_cellSelectedbyUser.cellSoundFilename == nil) {
//            return;
//        }
//        NSURL* url = [[NSURL alloc]initFileURLWithPath:[_cellSelectedbyUser.cellSoundFilename stringByExpandingTildeInPath]];
//        // the _audioplayer HAS to be declared global and allocated in viewDidLoad
//        //otherwise the AVAudioPlayer releases the object before playing => no sound heared
//        [_audioPlayer initWithContentsOfURL:url error:&error];
//
//        [_audioPlayer prepareToPlay];
//        [_audioPlayer setNumberOfLoops:0];
//        [_audioPlayer setVolume:0.5];
//        [_audioPlayer play];
//
//
//
//    }
//
//
//
//}
//



#pragma mark UICollectionViewDelegate

//#pragma functions for showing menu action
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    return YES;  // YES for the Cut, copy, paste actions
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    NSLog(@"performAction");
//}
//
//// UIMenuController required methods (Might not be needed on iOS 7)
//- (BOOL)canBecomeFirstResponder {
//    // NOTE: This menu item will not show if this is not YES!
//    return YES;
//}
//
//// NOTE: on iOS 7.0 the message will go to the Cell, not the ViewController. We need a delegate protocol
////  to send the message back. On iOS 6.0 these methods work without the delegate.
//
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    NSLog(@"canPerformAction");
//    // The selector(s) should match your UIMenuItem selector
//    if (action == @selector(customAction:)) {
//        return YES;
//    }
//    return NO;
//}
//
//// Custom Action(s) for iOS 6.0
//- (void)customAction:(id)sender {
//    NSLog(@"custom action! %@", sender);
//}
//
//// iOS 7.0 custom delegate method for the Cell to pass back a method for what custom button in the UIMenuController was pressed
//- (void)customAction:(id)sender forCell:(EditBoardCell_collectionviewcell *)cell {
//    NSLog(@"custom action on iOS 7.0");
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RunBoardCell_collectionviewcell* currCell = (RunBoardCell_collectionviewcell*)[collectionView cellForItemAtIndexPath:indexPath];
    //currCell.delegate=self;
    Cell_class* theCell = _arrayOfCells[indexPath.row];
    
    // change - 25-09-2015
    //theCell.coordinates =  CGPointMake(currCell.frame.origin.x, currCell.frame.origin.y);
    //---------------------
   // theCell.size = CGSizeMake(currCell.frame.size.width, currCell.frame.size.height);
   //todo - deal with
    // Play message
    // Process Links
    
    
   // NSIndexPath *indexPath = [_colEditBoard indexPathForCell:cell];
    _cellSelectedbyUser = _arrayOfCells[indexPath.row];
    
    // check if user made a voice recording
    
    if ([_cellSelectedbyUser.cellSoundFilename isEqualToString:@""]) {
        
        // he didn't, then use
        // Text - to - Speech
        
        Text2Speech* T2S = [[Text2Speech alloc]init];
        NSString* string = _cellSelectedbyUser.cellText;
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:string];
        NSLog(@"BCP-47 Language Code: %@", [T2S getGuessedUtteranceLanguageCode:string]);//   BCP47LanguageCodeForString(utterance.speechString));
        
        // guess user lang according to text
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[T2S getGuessedUtteranceLanguageCode:string]];
        NSLog(@"BCP-47 Language Code: %@", [T2S getGuessedUtteranceLanguageCode:string]);
        
        //utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[T2S getUtteranceLanguageCode:@"English"]];
        
        //    utterance.pitchMultiplier = 0.5f;
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        utterance.preUtteranceDelay = 0.0f; // 0.2f;
        utterance.postUtteranceDelay = 0.2f;
        
        AVSpeechSynthesizer *speechSynthesizer=[[AVSpeechSynthesizer alloc] init];
        speechSynthesizer.delegate = self;
        [speechSynthesizer speakUtterance:utterance];
    }
    else{
        // popupmenuPopoverController is declared as UIPopOverController
//        if ([self.popover isPopoverVisible]) {
//            [self.popover dismissPopoverAnimated:YES];
//        }
//        else
//        {
            NSFileManager* fileManager = [[NSFileManager alloc]init];
            if ([fileManager fileExistsAtPath:[_cellSelectedbyUser.cellSoundFilename stringByExpandingTildeInPath]])
            {
                NSLog(@"play sound -%@",_cellSelectedbyUser.cellSoundFilename);
                //[GlobalData playTrack:TMP_REC_PATH ext:@""];
                
                AVAudioSession * audioSession = [AVAudioSession sharedInstance];
                [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
                [audioSession setActive:YES error:nil];
                //init Audio Player
                NSURL* url = [[NSURL alloc]initFileURLWithPath:[_cellSelectedbyUser.cellSoundFilename stringByExpandingTildeInPath]];
                NSError * playerError;
                _audioPlayer = [_audioPlayer initWithContentsOfURL:url error:&playerError];
                //[_audioPlayer setDelegate:self];
                if (playerError!= nil)
                    NSLog(@"Player initialization error: %@",playerError.description);
                
                if ([self.audioPlayer prepareToPlay])
                {
                    //self.wasPlaying = YES;
                    NSLog(@"Player prepared");
                    [_audioPlayer play];
                }
                else
                {
                    NSLog(@"Player not prepared");
                }
                
            }
            
//        }
        
    }
    ///        // the _audioplayer HAS to be declared global and allocated in viewDidLoad
    //        //otherwise the AVAudioPlayer releases the object before playing => no sound heared
    //        [_audioPlayer initWithContentsOfURL:url error:&error];
    
    
    
    
    [colRunBoard reloadData];
    
    //    }
    
    //  NSLog(@"didSelectItemAtIndexPath x=%f, y=%f",theCell.coordinates.x,theCell.coordinates.y);
    
}

#pragma mark -
#pragma mark Misc Funcs

-(void)initBoard2
{
    //init the current display with the basic grid - 12x12 cells
    
    int cntCells=0;
    
    for (int i=0; i<NUMOFCELLSINCOL; i++){
        NSMutableArray* arrayRow = [[NSMutableArray alloc]init];
        
        for(int j=0;j<NUMOFCELLSINROW;j++)
        {
            //[arrayZ insertObject:@"" atIndex:j];
            NSString* str = [NSString stringWithFormat:@"%d",cntCells];
            Cell_class* cell = [[Cell_class alloc]init];
            cell.cellText=str;
            cell.cellBackgroundColor = [UIColor clearColor];
            cell.cellBorderColor = [UIColor darkGrayColor];
            cell.cellImageID=@"-1";//[NSNumber numberWithInt:-1];
            cell.size = CGSizeMake(1,1);
            cell.cellIndex = cntCells;
            // cell.tag=[NSNumber numberWithInt:i];
            cell.coordinates = CGPointMake(i,j);
            [cell.collection addObject:[NSValue valueWithCGPoint:cell.coordinates]];
            cell.cellBoardLink = 0;
            cell.cellCreatedBy = @"creator";
            cell.cellCreatedDate = [NSDate date];
            cell.cellMP3Path = @"";
            cell.cellSoundFilename = @"";
            cell.cellSoundPath = @"";
            cell.cellVIDEOPath = @"";
            cell.cellWEBPath = @"";
            cell.cellLastUpdatedBy = @"creator";
            cell.cellLastUpdateDate = [NSDate date];
            
            [arrayRow addObject:cell];
            cntCells++;
            [_arrayOfCells addObject:cell];
        }
        [_matrixOfCells addObject:arrayRow];
    }
}

-(void)rearange_objectsInCell:(RunBoardCell_collectionviewcell*)currCell
{
    CGSize cellSize = CGSizeMake(currCell.frame.size.width,currCell.frame.size.height);
    CGSize lblSize = CGSizeMake(cellSize.width-10, currCell.lblText.frame.size.height);
    CGPoint lblPoint;
    if (currCell.imgSymbol.image == nil)
        lblPoint = CGPointMake((cellSize.width-lblSize.width)/2, (cellSize.height-lblSize.height)/2);
    else
        lblPoint = CGPointMake((cellSize.width-lblSize.width)/2, (cellSize.height-lblSize.height-10));
    
    
    
    currCell.lblText.frame = CGRectMake(lblPoint.x, lblPoint.y, lblSize.width, lblSize.height);
    
    //imgSize is set for EDIT MODE
    //todo - for RUN MODE it has to changed
    CGSize imgSymbolSize = CGSizeMake((cellSize.width - 60), cellSize.height-lblSize.height-70);
    CGPoint imgSymbolPoint = CGPointMake((cellSize.width-imgSymbolSize.width)/2, (cellSize.height-imgSymbolSize.height-lblSize.height)/2);
    
    currCell.imgSymbol.frame = CGRectMake(imgSymbolPoint.x, imgSymbolPoint.y, imgSymbolSize.width, imgSymbolSize.height);
    currCell.imgSymbol.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
}

#pragma mark -
#pragma mark – RFQuiltLayoutDelegate

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row >= _arrayOfCells.count)
        NSLog(@"Asking for index paths of non-existant cells!! %ld from %lu cells", (long)indexPath.row, (unsigned long)_arrayOfCells.count);
    
    //    if (indexPath.row % 10 == 0)
    //        return CGSizeMake(3, 1);
    //    if (indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 1);
    //    else if (indexPath.row % 7 == 0)
    //        return CGSizeMake(1, 3);
    //    else if (indexPath.row % 8 == 0)
    //        return CGSizeMake(1, 2);
    //    else if(indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 2);
    //    if (indexPath.row == 0) return CGSizeMake(5, 5);
    //
    //    return CGSizeMake(1, 1);
    
    
    Cell_class* currCell = [_arrayOfCells objectAtIndex:indexPath.row];
    return CGSizeMake(currCell.size.width, currCell.size.height);
    // return CGSizeMake(3, 1);///    currCell.size;
}

- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (indexPath.item == 0) { // first item of section
    //                CGRect frame = _collGrid.contentI                  currentItemAttributes.frame;
    //                frame.origin.x = sectionInset.left; // first item of the section should always be left aligned
    //                currentItemAttributes.frame = frame;
    //
    //        return currentItemAttributes;
    //    }
    
    
    return UIEdgeInsetsMake(2, 2, 2, 2);
    
}

@end
