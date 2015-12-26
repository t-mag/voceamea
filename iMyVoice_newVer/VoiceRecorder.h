//
//  VoiceRecorder.h
//  MyVoice
//
//  Created by Ruslan Mishin on 02.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "AlertPrompt.h"

typedef enum
{
    ENC_AAC = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM =6,
} EncodingTypes;

@protocol VoiceRecorderProtocol
- (void)closePopoverCtrlr:(UIPopoverController*)popoverCtrlr;
@end

//=================================================
@interface VoiceRecorder : UIViewController <AVAudioRecorderDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>

//@property (nonatomic) BOOL recordFinished;
@property (nonatomic) BOOL hasChanges;
@property (nonatomic,retain) NSString * recordName;
@property (nonatomic,retain) AVAudioRecorder * audioRecorder;
@property (nonatomic,retain) AVAudioPlayer * audioPlayer;
@property (nonatomic,retain) UIPopoverController * parentPopoverController;

//new - Simona - 16-11-15
@property CGRect rectVoiceRecorderFrame;

- (id) initWithDelegate:(id<VoiceRecorderProtocol>)newDelegate;

@end
