//
//  XMLmanager_class.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 20/5/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "Images_class.h"
#import "BoardsList_class.h"
#import "XMLWriter.h"

@interface XMLmanager_class : NSObject <NSXMLParserDelegate>
@property NSMutableArray* arrayOfImagesRecords;
@property NSMutableArray* array4LoadedBoard;
@property NSXMLParser* parser;
//@property NSXMLParser* parserBoard;
//@property id<XMLStreamWriter> xmlWriter;
@property Images_class* imgRecords;
@property BoardsList_class* brdRecords;
@property NSString* path4SaveImages;
@property BOOL* imagesExists;
@property NSString* packageName;
@property GlobalsFunctions_class* globalFuncs;
@property int cntCellsPerRow;
@property NSMutableArray* array4MatrixRow;

-(id)loadImagesFromServerbyPath:(NSString*) serverXML_FullFilename andwithPackageName:(NSString*)sPackageName;
-(void)createImagesLocalXMLfile:(NSString*)sComment andwith:(NSArray*)arraySourceData;
-(void)createBoardLocalXMLfilewithComment:(NSString*)sComment withData:(NSArray*)arraySourceData andwithBoardName:(NSString*)strBoardName;

-(void)createBoardsList_localXMLfile:(NSString*)sComment andwith:(NSArray*)arraySourceData;
-(id)loadBoardData:(BoardsList_class*)board4Loading;
-(void)createBoardsList_fromBoardsFolder:(NSArray*) arrayfolderContents;




@end
