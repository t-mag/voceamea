//
//  Globals.h
//  PingMe
//
//  Created by Ruslan Mishin on 15.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//#import "MyVoiceAppDelegate.h"
//#import "GlobalData.h"

// Globals  - by Simona 05-2015

//AppDelegate
#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])

//Directories
#define LIBRARY_MAIN_FOLDER    [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DOCUMENTS_MAIN_FOLDER    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


//Prefixes
#define PREFIX_USER_IMAGES                  @"IU"
#define PREFIX_WIDGIT_IMAGES                @"IW"
#define PREFIX_SYMBOLSTIX_IMAGES            @"ISS"
#define PREFIX_FREE_IMAGES                  @"IF"
#define PREFIX_TEST_IMAGES                  @"ITST"


//Images
#define IMAGESAVE_ALERT_TITLE                 @"iMyVoice - Save Image"

//Images Class
#define IMAGECLASS_DESCRIPTION                @"general"
#define IMAGECLASS_DEFAULTCATEGORY            @"general"
#define IMAGECLASS_DEFAULTUSER                @"admin"
#define IMAGECLASS_DEFAULTPROMPT              @""
#define IMAGECLASS_DEFAULTTYPE                @""



//Symbols
#define SYMBOLS_ALERT_TITLE                 @"iMyVoice - Add Symbol"
#define SYMBOLS_MAIN_FOLDER                 @"symbols"
#define SYMBOLS_FOLDER_FOR_SYMBOLSTIX       [SYMBOLS_MAIN_FOLDER stringByAppendingPathComponent:@"symbolstix"]
#define SYMBOLS_FOLDER_FOR_WIDGIT           [SYMBOLS_MAIN_FOLDER stringByAppendingPathComponent:@"widgit"]
#define SYMBOLS_FOLDER_FOR_PCS              [SYMBOLS_MAIN_FOLDER stringByAppendingPathComponent:@"pcs"]
#define SYMBOLS_FOLDER_FOR_FREE             [SYMBOLS_MAIN_FOLDER stringByAppendingPathComponent:@"free"]
#define SYMBOLS_FOLDER_FROM_USER            [SYMBOLS_MAIN_FOLDER stringByAppendingPathComponent:@"user"]
#define SYMBOLS_FOLDER_FOR_TEST             [SYMBOLS_MAIN_FOLDER stringByAppendingPathComponent:@"tmp"]

//Board
#define NUMOFCELLSINCOL                      12
#define NUMOFCELLSINROW                      12
#define BOARDS_MAIN_FOLDER                   @"boards"
#define BOARD_ALERT_TITLE                    @"iMyVoice - Save Board"
#define BOARDSAMENAME_ALERT_TITLE            @"iMyVoice - Board exists"

//Cell
#define CELLDEFAULTBACKGROUNDCOLOR           [UIColor whiteColor]
#define CELLDEFAULTFRAMECOLOR                [UIColor blackColor]
#define CELLDEFAULTFRAMEWIDTH                1
#define CELLDEFAULTFONTCOLOR                 [UIColor blackColor]
#define CELLDEFAULTFONT                      [UIFont fontWithName:@"Helvetica" size:12]
#define CELLDEFAULTFONTSIZE                  12
#define CELLDEFAULTFONTTYPE                  0 //regular

//CellEdit window - Objects definitions
#define TOOLBARHIGH                         50
#define FONTDESCRIPTIONSIZE                 17


//Voices
#define VOICES_ALERT_TITLE                  @"iMyVoice - Voice Recording"
#define VOICES_MAIN_FOLDER                  @"voices"
#define VOICES_FOLDER_FROM_RECORDINGS       [VOICES_MAIN_FOLDER stringByAppendingPathComponent:@"recordings"]
#define VOICES_FOLDER_FOR_SYNTH             [VOICES_MAIN_FOLDER stringByAppendingPathComponent:@"synth"]
#define VOICES_FOLDER_FOR_TEST              [VOICES_MAIN_FOLDER stringByAppendingPathComponent:@"tmp"]
#define VOICES_EXT                          @"aiff"
#define VOICE_PREFIX_LENGTH                 3
#define VOICE_PREFIX_SEPARATOR              @"_"
#define BUTTON_IMAGE_SCALE_FACTOR_Y         0.6
#define BUTTON_IMAGE_SCALE_FACTOR_X         0.6
#define MAX_RECORDING_DURATION              60.0

//Text
#define TEXT_ALERT_TITLE                    @"iMyVoice - Edit Text"


//View Sizes
//List of Images
#define IMAGELIST_VIEW_SIZE_H               350
#define IMAGELIST_VIEW_SIZE_W               270
//board menu
#define BOARDMENU_VIEW_SIZE_H               350
#define BOARDMENU_VIEW_SIZE_W               300




// Globals from MyVoice OLEG's version
#define APP_VER                 @"2.2"

#define USE_EXTERNAL_OPTIONS_STORAGE        NO
#define IS_ENGLISH_DEFAULT                  NO
#define ENABLE_BUILD_SENTENCE_MODE          NO

//#define VOICES_EXT                          @".aiff"
//#define VOICE_PREFIX_LENGTH                 3
//#define VOICE_PREFIX_SEPARATOR              @"_"
//#define BUTTON_IMAGE_SCALE_FACTOR_Y         0.6
//#define BUTTON_IMAGE_SCALE_FACTOR_X         0.6
//#define MAX_RECORDING_DURATION              60.0


#define WEBVIEW_HOME_PAGE                   @"http://www.tmag.co.il"

//UNIVERSAL FUNCTIONS
#define IS_STR_EMPTY(iseStr)    ((iseStr==nil)||([iseStr isEqualToString:@""]))
//-----------------------------
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define TMP_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
//-----------------------------
#define screenW                 [[UIScreen mainScreen] bounds].size.width
#define screenH                 [[UIScreen mainScreen] bounds].size.height
//-----------------------------
#define DEVICE_IPAD         [[[[UIDevice currentDevice] model] lowercaseString] hasPrefix:@"ipad"]
//-----------------------------
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//-----------------------------

#define THIS_APP_DELEGATE       [GlobalData thisAppDelegate]

#define StrTrue                 @"true"
#define StrFalse                @"false"

//-----------------------------
#define OPTIONS_FILE_NAME       @"options.cnf"

//=========================================================
//=== UserDefaults ========================================

#define F_NOT_1ST_START         @"not1stStart"
#define F_UUID                  @"UUID"
#define AppUUID                 [[NSUserDefaults standardUserDefaults] objectForKey:F_UUID]
//options in UserDefaults
#define F_USE_BUILD_SENTENCE_MODE   @"useBuildSentenceMode"
#define F_IS_DEF_VOICE_MALE     @"isDefVoiceMale"

//=========================================================
// OPTIONS
#define NUMBER_OF_OPTIONS       15
#define OPT_IS_ENGLISH          @"isEnglish"
#define OPT_IS_SCAN             @"isScan"
#define OPT_IS_TEXT_POSITION_UP @"isTextPositionUp"
#define OPT_IS_BOLD             @"isBold"
#define OPT_IS_ITALIC           @"isItalic"
#define OPT_SCAN_DELAY          @"scanDelay"
#define OPT_MAIN_BOARD_ID       @"mainBoardID"
#define OPT_SCAN_BORDER         @"scanBorder"
#define OPT_IPAD_FONT_SIZE      @"iPadFontSize"
#define OPT_USE_BUILD_SENTENCE  @"useBuildSentenceMode"
#define OPT_IS_DEF_VOICE_MALE   @"isDefVoiceMale"
#define OPT_PASS                @"pass"
#define OPT_AUTOSAVE_BOARD_ID   @"autoSaveBoardID"
#define OPT_DWEALL_TIME         @"dwellTime"
#define OPT_RELEASE_TIME        @"releaseTime"
#define OPT_ACTIVE_TIME         @"active Time"
#define OPT_ACTIVE_PASS         @"active pass"
//=========================================================
// AUTOSAVE
#define AUTOSAVE_NAME               @"autosave"

//=========================================================
// ButtonsSubviewTags
#define TAG_JUMPBAR_CAPTION     5000
#define TAG_LINK                1234
#define TAG_DELETE              1235
#define TAG_IMAGE_ADD           1236
#define TAG_SOUND_ADD           1237
#define TAG_LABEL               1238
#define TAG_IMAGE               1239
#define TAG_BACK                1240
#define TAG_WEB                 1241
#define TAG_MUSIC               1242
#define TAG_MOVIE               1243
#define TAG_LOGO_BUTTON         1244

#define XSafeRelease(Object) \
if (Object != nil) {\
[Object release];\
Object = nil;\
}
