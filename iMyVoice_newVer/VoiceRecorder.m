//
//  VoiceRecorder.m
//  MyVoice
//
//  Created by Ruslan Mishin on 02.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoiceRecorder.h"
#import "Globals.h"
//#import "AlertSyncYesNo.h"

#define TMP_REC_FILE        @"rec.aiff"
#define TMP_REC_PATH        [NSString stringWithFormat:@"%@/%@",TMP_FOLDER,TMP_REC_FILE]

@interface VoiceRecorder()

@property (nonatomic,retain) UIButton * btnRecStop;
@property (nonatomic,retain) UIButton * btnPlay;
@property (nonatomic,retain) UIButton * btnSave;
@property (nonatomic,retain) UIProgressView * progressView;
@property (nonatomic,retain) UILabel * timerLabel;
@property (nonatomic) NSInteger recordEncoding;
@property (nonatomic,retain) NSError * recError;
@property (nonatomic,retain) NSTimer * recTimer;
@property (nonatomic,retain) NSTimer * playTimer;
@property (nonatomic) BOOL hasRecord;
@property (nonatomic) BOOL wasPlaying;

@property (nonatomic,retain) id <VoiceRecorderProtocol>delegate;

@end

//==================================================
@implementation VoiceRecorder

@synthesize hasChanges;
@synthesize recordName;
@synthesize btnRecStop, btnPlay, btnSave, progressView, timerLabel;
@synthesize audioRecorder,audioPlayer;
@synthesize recordEncoding;
@synthesize recError;
@synthesize recTimer,playTimer;
@synthesize hasRecord;
@synthesize parentPopoverController;
@synthesize delegate;
@synthesize wasPlaying;
//new - Simona - 16-11-15
@synthesize rectVoiceRecorderFrame;

//--------------------------------------------------
- (void) askDelegateToClosePopover{
   // if ((self.delegate!=nil)&&(parentPopoverController!=nil)){
       //old ver -  [self.delegate closePopoverCtrlr:parentPopoverController];
  //  NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
  //  [notificationCenter postNotificationName:@"dismisspopover" object:nil];

  //  }
}
//--------------------------------------------------
- (void) onRecTimer:(id)sender{
    //[progressView setProgress:(audioRecorder.currentTime/MAX_RECORDING_DURATION)];
    [audioRecorder updateMeters];
    float decibels = [audioRecorder averagePowerForChannel:0];
    float linear = pow (10, decibels / 20);
    [progressView setProgress:MIN((linear*2),1.0)];
    NSInteger minutes = (NSInteger)trunc(audioRecorder.currentTime/60);
    NSInteger seconds = (NSInteger)(audioRecorder.currentTime - 60*minutes);
    timerLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
}

//--------------------------------------------------
- (void) onPlayTimer:(id)sender{
    //[progressView setProgress:(audioRecorder.currentTime/MAX_RECORDING_DURATION)];
    if ((NSInteger)audioPlayer.duration > 0){
        [progressView setProgress:(audioPlayer.currentTime/audioPlayer.duration)];
    }else{
        [progressView setProgress:0.0];
    }
    
    NSInteger minutesD = (NSInteger)trunc(audioPlayer.duration/60);
    NSInteger secondsD = (NSInteger)(audioPlayer.duration-60*minutesD);
    NSInteger minutes = (NSInteger)trunc(audioPlayer.currentTime/60);
    NSInteger seconds = (NSInteger)(audioPlayer.currentTime - 60*minutes);
    timerLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld",(long)minutes,(long)seconds,(long)minutesD,secondsD];
}

//--------------------------------------------------
- (NSMutableDictionary*) recordSettingsForEncoding:(EncodingTypes)encodingType{
    NSMutableDictionary * recordSettings = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    if (encodingType == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];   
        
    }else{
        NSNumber *formatObject;
        
        switch (encodingType) {
            case (ENC_AAC): 
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    return  recordSettings;
}

//--------------------------------------------------
- (void) initRecorder{
   // NSMutableDictionary * recordSettings = [[self recordSettingsForEncoding:self.recordEncoding] retain];
     NSMutableDictionary * recordSettings = [self recordSettingsForEncoding:self.recordEncoding];
    NSURL * url = [NSURL fileURLWithPath:TMP_REC_PATH];
   // audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&recError];
     audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:nil];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
  //  [recordSettings release];
}
//--------------------------------------------------
- (void) initPlayer{
    self.audioPlayer = [[AVAudioPlayer alloc] init];
}

#pragma mark - AVAudioRecorderDelegate, AVAudioPlayerDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [progressView setProgress:0.0];
    [btnPlay setEnabled:flag];
    [btnSave setEnabled:flag];
    [btnRecStop setSelected:NO];
    if (flag){
        self.hasChanges = YES;
        self.hasRecord = YES;
    }
    if ([recTimer isValid])
        [recTimer invalidate];
    //[audioRecorder release];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"audioPlayerDidFinishPlaying");
    [self onPlayTimer:nil];
    if ([playTimer isValid]){
        [playTimer invalidate];
    }
    [btnRecStop setEnabled:YES];
    [btnSave setEnabled:YES];
    [btnPlay setSelected:NO];
}
//--------------------------------------------------
#pragma mark - on Buttons Click
- (IBAction)onRecStopBtnClick:(id)sender{
    [progressView setProgress:0.0];
    if (!audioRecorder.recording){
        [timerLabel setText:@"00:00"];
        UIButton * btn = (UIButton*)sender;
        
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        [audioSession setActive:YES error:nil];
        if (self.hasRecord){
            [audioRecorder deleteRecording];
            self.hasRecord = NO;
        }
        if ([audioRecorder prepareToRecord] == YES){
            [audioRecorder recordForDuration:MAX_RECORDING_DURATION];
            [btnPlay setEnabled:NO];
            [btnSave setEnabled:NO];
            [btn setSelected:YES];
            recTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onRecTimer:) userInfo:nil repeats:YES];
        }else {
            int errorCode = CFSwapInt32HostToBig ([recError code]); 
            NSLog(@"Error: %@ [%4.4s])" , [recError localizedDescription], (char*)&errorCode); 
            [btn setSelected:NO];
            //[audioRecorder release];
        }
    }else{
        [audioRecorder stop];
    }
}

//--------------------------------------------------
- (IBAction)onPlayBtnClick:(id)sender{
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    //if (!audioPlayer.playing){
    if (!btnPlay.selected){
        if ([fileManager fileExistsAtPath:TMP_REC_PATH]){
            //[GlobalData playTrack:TMP_REC_PATH ext:@""];
            
            AVAudioSession * audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            [audioSession setActive:YES error:nil];
            //init Audio Player
            NSURL * url = [NSURL fileURLWithPath:TMP_REC_PATH];
            NSError * playerError;
            self.audioPlayer = [self.audioPlayer initWithContentsOfURL:url error:&playerError];
            [self.audioPlayer setDelegate:self];
            if (playerError!= nil){
                NSLog(@"Player initialization error: %@",playerError.description);
            }
            if ([self.audioPlayer prepareToPlay]){
                self.wasPlaying = YES;
                NSLog(@"Player prepared");
                [self.audioPlayer play];
                NSInteger minutes = (NSInteger)trunc(audioPlayer.duration/60);
                NSInteger seconds = (NSInteger)(audioPlayer.duration-60*minutes);
                [timerLabel setText:[NSString stringWithFormat:@"00:00 / %02ld:%02ld",(long)minutes,(long)seconds]];
                [progressView setProgress:0.0];
                self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onPlayTimer:) userInfo:nil repeats:YES];
                [btnRecStop setEnabled:NO];
                [btnSave setEnabled:NO];
                [btnPlay setSelected:YES];
            }else{
                NSLog(@"Player not prepared");
            }
            
        }else{
            [btnSave setEnabled:NO];
            [btnPlay setEnabled:NO];
            [btnPlay setSelected:NO];
        }
    //    [fileManager release];
    }else{
        [self.audioPlayer stop];
        [self audioPlayerDidFinishPlaying:audioPlayer successfully:YES];
    }
}

//--------------------------------------------------
- (IBAction)onSaveBtnClick:(id)sender
{
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:TMP_REC_PATH])
    {
        UIAlertView* inpDialog = [[UIAlertView alloc]initWithTitle: VOICES_ALERT_TITLE message:@"Save recording as ..." delegate:self cancelButtonTitle: @"Save" otherButtonTitles: @"Cancel", nil];
        
        inpDialog.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [inpDialog show];
        
        
     //   AlertPrompt *prompt = [AlertPrompt alloc];
//        prompt = [prompt initWithTitle: [THIS_APP_DELEGATE myLocalizedString: @"Enter voice name"] message:@"" delegate:self cancelButtonTitle: [THIS_APP_DELEGATE myLocalizedString: @"Cancel"] okButtonTitle:[THIS_APP_DELEGATE myLocalizedString: @"Save"]];
   //     prompt = [prompt initWithTitle: @"Enter voice name" message:@"" delegate:self cancelButtonTitle: @"Cancel" okButtonTitle: @"Save"];
//        prompt.mDelegate = self;
//        prompt.textField.autocorrectionType = UITextAutocorrectionTypeNo; 
//        prompt.textField.clearButtonMode = UITextFieldViewModeAlways;
//        prompt.tag = 1;
//        [prompt show];
     //   [prompt release];
    }
    else
        {
            [btnSave setEnabled:NO];
            [btnPlay setEnabled:NO];
        }
   // [fileManager release];
}

//--------------------------------------------------
#pragma mark - AlertPromptDelegate, , UIAlertViewDelegate
- (void) saveRecordWithName:(NSString*)baseName
{
    NSError* error;
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    
    if (![fileManager fileExistsAtPath:TMP_REC_PATH])
    {
        NSLog(@"ERROR! Recorded file not exist");
        [btnSave setEnabled: NO];
        [btnPlay setEnabled: NO];
    }
    else
    {
//        if (IS_STR_EMPTY(baseName))
//        {
//            NSLog(@"ERROR! Entered empty name");
//        }
//        else
//            {
//                NSMutableString * newFileName = [NSMutableString stringWithString:baseName];
//                NSArray * badSymbols = [NSArray arrayWithObjects:@"/",@"*",@"?",@"'",@"\"",@"!",@"$", nil];
//                
//                for (NSString * symbol in badSymbols)
//                {
//                    [newFileName replaceOccurrencesOfString:symbol withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[newFileName length]-1)];
//                }
        
        NSString* recPath = [LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:VOICES_FOLDER_FROM_RECORDINGS];
        
        
        if (![fileManager fileExistsAtPath:recPath]) {
            [fileManager createDirectoryAtPath:recPath withIntermediateDirectories:TRUE attributes:nil error:&error];
        }
        
        
        NSString* recFullname = [recPath stringByAppendingPathComponent:baseName];

        recFullname = [recFullname stringByAppendingPathExtension:@"caf"];//VOICES_EXT];
        
        //NSString * newFilePath = [NSString stringWithFormat:@"%@/%@%@",DOCUMENTS_FOLDER,baseName,([baseName hasSuffix:VOICES_EXT]?@"":VOICES_EXT)];
        
                BOOL commited = YES;
                if ([fileManager fileExistsAtPath:recFullname])
                {
//                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:VOICES_ALERT_TITLE message:@"Recording allready exists. Overwrite it ?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                    
                    
                    
               // {
                   // AlertSyncYesNo * alertSync = [[AlertSyncYesNo alloc] init];
                  //  commited = [alertSync showSyncAlertWithTitle:[THIS_APP_DELEGATE myLocalizedString:@"Voice already exist. Replace it?"] message:nil];
                  //   commited = [alertSync showSyncAlertWithTitle:@"Voice already exist. Replace it?" message:nil];
                  //  [alertSync release];
                }
        
                if (commited)
                {
                    NSError * error;
                    
                    //if ([fileManager fileExistsAtPath:recFullFilename])
                     //   [fileManager removeItemAtPath: newFilePath error: &error];

                    
                    [fileManager copyItemAtPath:TMP_REC_PATH toPath:recFullname error:&error];
                    self.recordName = [NSString stringWithString:recFullname];
                    self.hasChanges = NO; //from old ver
                    
                    
                    //announce that user made and saved a voice message
                    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter postNotificationName:@"messagerecorded" object:self.recordName];
                      
                      
                     
                    
                  //§  [GlobalData showAlertOkLoc:[THIS_APP_DELEGATE myLocalizedString:@"Voice saved!"] message:nil];
                }
            }
   // [fileManager release];
}

- (void)alertPromptReturnKeyPressed:(NSString *)enteredText
{
    NSLog(@"alertPromptReturnKeyPressed with text: %@", enteredText);
    [self saveRecordWithName: enteredText];
    [self askDelegateToClosePopover];    
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if (alertView.tag == 1)
    //{
        //[[(AlertPrompt*)alertView textField] resignFirstResponder];
        if (buttonIndex == 0)
        {
            NSString* inpText = [alertView textFieldAtIndex:0].text;
            NSLog(@"VoiceRecording - user pressed SAVE to file: %@",inpText);//[(AlertPrompt*)alertView enteredText]);
            
           
            if (IS_STR_EMPTY(inpText))
            {
                NSLog(@"ERROR! Entered empty name");
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"iMyVoice" message:@"Name of the recording can't be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                //todo - insert code for retype name of the current recording
                return;
            }
            else
            {
                NSMutableString * newFileName = [NSMutableString stringWithString:inpText];
                NSArray * badSymbols = [NSArray arrayWithObjects:@"/",@"*",@"?",@"'",@"\"",@"!",@"$", nil];
                
                for (NSString * symbol in badSymbols)
                {
                    [newFileName replaceOccurrencesOfString:symbol withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[newFileName length]-1)];
                }

            }
            
            [self saveRecordWithName:inpText];//[(AlertPrompt*)alertView enteredText]];
            [self askDelegateToClosePopover];
        }
    else
    {
        [self askDelegateToClosePopover];
    }
   // }
}


//--------------------------------------------------
#pragma mark - View and ViewController lifecycle

- (id) init{
    self = [super init];
    if (self){
        //delete previous records
        parentPopoverController = nil;
        NSFileManager * fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:TMP_REC_PATH]){
            NSError * error;
            [fileManager removeItemAtPath:TMP_REC_PATH error:&error];
        }
      //  [fileManager release];
        
        //self.recordFinished = NO;
        self.hasChanges = NO;
        self.recordName = @"";
        self.recordEncoding = ENC_PCM;
        self.hasRecord = NO;
        self.wasPlaying = NO;
        [self initRecorder];
        [self initPlayer];
    }
    return self;
}

//--------------------------------------------------
- (id) initWithDelegate:(id<VoiceRecorderProtocol>)newDelegate{
   // [self init];
    self.delegate = newDelegate;
    return self;
}
//--------------------------------------------------
- (void) dealloc{
   // [audioRecorder release];
   // [audioPlayer release];
  //  [super dealloc];
}

//--------------------------------------------------
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

//--------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (audioRecorder.recording){
        [audioRecorder stop];
    }
    if ((self.wasPlaying)&&(audioPlayer.playing)){
        [audioPlayer stop];
    }
}

//--------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:rectVoiceRecorderFrame];
    //self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 150.0)];
    [self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [self.view setAutoresizingMask:UIViewAutoresizingNone];
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];     //UIProgressViewStyleBar];
    [progressView setFrame: CGRectMake(22, 5 + 60, self.view.frame.size.width - 50, 32)];
    [progressView setProgress: 0.0];
    
    //UIImage *track = [[UIImage imageNamed:@"progressbar_outer.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    
   // UIImage *progress = [[UIImage imageNamed:@"progressbar_inner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    
    [progressView setTrackImage:[UIImage imageNamed:@"progressbar_outer.png"]];
    [progressView setProgressImage:[UIImage imageNamed:@"progressbar_inner.png"]];
  
    [self.view addSubview:progressView];
    [progressView setHidden:NO];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    progressView.transform = transform;
 
    
    timerLabel = [[UILabel alloc] init];
    [timerLabel setFrame:CGRectMake(0.0, 0.0, progressView.frame.size.width, 48.0)];
    [timerLabel setCenter:CGPointMake(self.view.frame.size.width/2, 30)];
    [timerLabel setTextColor:[UIColor blueColor]];
    [timerLabel setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.0]];
    [timerLabel setTextAlignment:NSTextAlignmentCenter];
    [timerLabel setFont:[UIFont systemFontOfSize:40.0]];
    [timerLabel setText:@"00:00"];
    [timerLabel setHidden:NO];
    [self.view addSubview:timerLabel];
  //  [timerLabel release];
    
    CGFloat btnWidth  = 64.0;
    CGFloat btnHeight = 64.0;
    CGFloat btnSpace = (self.view.frame.size.width/3) - btnWidth;
    CGFloat baseY = self.view.frame.size.height - btnHeight - 10.0;
    
    btnRecStop = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRecStop setFrame:CGRectMake((btnWidth+btnSpace)*(1-1)+(btnSpace/2), baseY, btnWidth, btnHeight)];
    [btnRecStop setImage:[UIImage imageNamed:@"record-icon.png"] forState:UIControlStateNormal];
    [btnRecStop setImage:[UIImage imageNamed:@"control_stop_blue.png"] forState:UIControlStateSelected];

    [btnRecStop addTarget:self action:@selector(onRecStopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnRecStop setHidden:NO];
    [self.view addSubview:btnRecStop];
    
    btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPlay setFrame:CGRectMake((btnWidth+btnSpace)*(2-1)+(btnSpace/2), baseY, btnWidth, btnHeight)];
    [btnPlay setImage:[UIImage imageNamed:@"control_play_blue.png"] forState:UIControlStateNormal];
    [btnPlay setImage:[UIImage imageNamed:@"control_play.png"] forState:UIControlStateDisabled];
    [btnPlay setImage:[UIImage imageNamed:@"control_stop_blue.png"] forState:UIControlStateSelected];

    [btnPlay addTarget:self action:@selector(onPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnPlay setEnabled:NO];
    [btnPlay setHidden:NO];
    [self.view addSubview:btnPlay];
    
    btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave setFrame:CGRectMake((btnWidth+btnSpace)*(3-1)+(btnSpace/2), baseY, btnWidth, btnHeight)];
    [btnSave setImage:[UIImage imageNamed:@"save_as.png"] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(onSaveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setEnabled:NO];
    [btnSave setHidden:NO];
    [self.view addSubview:btnSave];
    
    
}

//--------------------------------------------------
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

//--------------------------------------------------
- (void)viewDidUnload
{
    NSLog(@"VoiceRecorderVC::viewDidLoad");

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//--------------------------------------------------
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
}

@end
