//
//  XMLmanager_class.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 20/5/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "XMLmanager_class.h"
//#import "Globals.h"
//#import "GlobalsFunctions_class.h"
#import "AppDelegate.h"
#import "XMLWriter.h"
#import "Board_class.h"
#import "Cell_class.h"




@implementation XMLmanager_class
@synthesize arrayOfImagesRecords,array4LoadedBoard,parser,imgRecords,path4SaveImages,imagesExists,packageName,globalFuncs,brdRecords,cntCellsPerRow,array4MatrixRow;





#pragma mark Handling IMAGES
#pragma mark -
#pragma mark Handle Images from Server

-(id)init
{
    self = [super init];
    self.cntCellsPerRow = 0;
    
    return  self;
}

-(id)loadImagesFromServerbyPath:(NSString*) serverXML_FullFilename andwithPackageName:(NSString*)sPackageName
{
    packageName = sPackageName;
    NSError* error;
    NSString* fileXML;
    NSData* data;
    globalFuncs = [[GlobalsFunctions_class alloc]init];
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
   
    NSString* dirPackage;
    if ([sPackageName isEqualToString:@"WIDGIT"]) {
      //  dirPackage = [globalFuncs getFullDirectoryPathfor:SYMBOLS_FOLDER_FOR_WIDGIT];
        dirPackage = SYMBOLS_FOLDER_FOR_WIDGIT;
    }
    
    [filemanager createDirectoryAtPath:[globalFuncs getFullDirectoryPathfor:dirPackage] withIntermediateDirectories:YES attributes:nil error:&error];
 
    fileXML = serverXML_FullFilename;
    NSURL* url = [[NSURL alloc]initWithString:fileXML];
    data = [[NSData alloc]initWithContentsOfURL:url];
    path4SaveImages = dirPackage;
    
    arrayOfImagesRecords = [[NSMutableArray alloc]init];
    
    parser = [[NSXMLParser alloc]initWithData:data];
    parser.delegate=self;
    
    [parser parse];
    
    AppDelegate* appDelegate = DELEGATE;
    appDelegate.arrayOfImages = arrayOfImagesRecords;
    
    return self;
}

-(void)createImagesLocalXMLfile:(NSString*)sComment andwith:(NSArray*)arraySourceData
{
    //id<XMLStreamWriter> xmlWriter = [[XMLWriter alloc]init];
    
    NSLog(@"createImagesLocalXMLfile");
    
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    xmlWriter=[self createXMLheader:xmlWriter andwith:sComment];
    
    // add root element
    [xmlWriter writeStartElement:@"images"];
    
    for (imgRecords in arraySourceData)
    {
        xmlWriter=[self createImagesXMLBodywith:xmlWriter andwith:imgRecords];
    }
    
    NSData* data  = [self createXMLEndwith:xmlWriter].toData;
    
    NSString* fileXML;
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    // NSString* dirLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dirMainSymbols = [LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:SYMBOLS_MAIN_FOLDER];
    fileXML = [dirMainSymbols stringByAppendingPathComponent:@"images_list.xml"];
    
    [filemanager createDirectoryAtPath:dirMainSymbols withIntermediateDirectories:YES attributes:nil error:nil];
    
    [data writeToFile:fileXML atomically:YES];
    
    // sent when the parser has completed parsing. If this is encountered, the parse was successful.
    NSLog(@"XML is DONE");
    
}



-(XMLWriter*)createImagesXMLBodywith:(XMLWriter*) xmlWriter andwith:(Images_class*)imgRec
{
    
    
    // add element with an attribute and some some text
    [xmlWriter writeStartElement:@"image"];
    [xmlWriter writeAttribute:@"category" value:imgRec.imgCategory];
    [xmlWriter writeAttribute:@"createdby" value:imgRec.imgCreatedBy];
    [xmlWriter writeAttribute:@"createddate" value:[NSString stringWithFormat:@"%@",imgRec.imgCreatedDate]];
    [xmlWriter writeAttribute:@"description" value:imgRec.imgDescription];
    [xmlWriter writeAttribute:@"filename" value:imgRec.imgFileName];
    [xmlWriter writeAttribute:@"index" value:[NSString stringWithFormat:@"%@",imgRec.imgIndex]];
    [xmlWriter writeAttribute:@"lastupdatedby" value:imgRec.imgLastUpdatedBy];
    [xmlWriter writeAttribute:@"lastupdateddate" value:[NSString stringWithFormat:@"%@",imgRec.imgLastUpdatedDate]];
    [xmlWriter writeAttribute:@"path" value:imgRec.imgPath];
    [xmlWriter writeAttribute:@"prompt" value:imgRec.imgPrompt];
    [xmlWriter writeAttribute:@"showname" value:imgRec.imgShowName];
    [xmlWriter writeAttribute:@"type" value:imgRec.imgType];
    
    
    //[xmlWriter writeCharacters:@"This element has an attribute"];
    [xmlWriter writeEndElement];
    
    return xmlWriter;
    
}





#pragma mark -
#pragma mark Handle Images from User Folder


-(void)createXMLList_fromSymbolsUserFolder:(NSArray*) arrayfolderContents
{
    // create xmlfile for images in symbols/user folder
    //then add the images to arrayofimages
    
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    xmlWriter=[self createXMLheader:xmlWriter andwith:@"Images from Symbols/User"];
    
    // add root element
    [xmlWriter writeStartElement:@"user_images"];
    
    NSString* imageFilename = @"";
    for (imageFilename in arrayfolderContents)
    {
        xmlWriter=[self createUserImagesListXMLBodywith:xmlWriter with:nil andwithFilename:imageFilename];
    }
    
    NSData* data  = [self createXMLEndwith:xmlWriter].toData;
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
  //  NSString* dirLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dirUserImages = [LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:BOARDS_MAIN_FOLDER];
    NSString* fileXML = [dirUserImages stringByAppendingPathComponent:@"userimages_list.xml"];
    
    [filemanager createDirectoryAtPath:dirUserImages withIntermediateDirectories:YES attributes:nil error:nil];
    
    [data writeToFile:fileXML atomically:YES];
    
    // sent when the parser has completed parsing. If this is encountered, the parse was successful.
    NSLog(@"XML is DONE");
    
}


-(XMLWriter*)createUserImagesListXMLBodywith:(XMLWriter*) xmlWriter with:(Images_class*)imgRec andwithFilename:(NSString*)sFilename
{
    //sFilename is used when creating the list directly from the existing files
    
    // add element with an attribute and some some text
    [xmlWriter writeStartElement:@"image"];
    
    if (sFilename != nil) {
        
        // add element with an attribute and some some text
       // [xmlWriter writeStartElement:@"image"];
        [xmlWriter writeAttribute:@"category" value:IMAGECLASS_DEFAULTCATEGORY];
        [xmlWriter writeAttribute:@"createdby" value:IMAGECLASS_DEFAULTUSER];
        [xmlWriter writeAttribute:@"createddate" value:[NSString stringWithFormat:@"%@",[NSDate date]]];
        [xmlWriter writeAttribute:@"description" value:IMAGECLASS_DESCRIPTION];
        [xmlWriter writeAttribute:@"filename" value:sFilename];
        NSNumber* numImageIndex = [NSNumber numberWithInteger:[[globalFuncs removeFilePrefix:sFilename prefixIs:PREFIX_USER_IMAGES] integerValue]];

        [xmlWriter writeAttribute:@"index" value:[NSString stringWithFormat:@"%@",numImageIndex]];
        [xmlWriter writeAttribute:@"lastupdatedby" value:IMAGECLASS_DEFAULTUSER];
        [xmlWriter writeAttribute:@"lastupdateddate" value:[NSString stringWithFormat:@"%@",[NSDate date]]];
        [xmlWriter writeAttribute:@"path" value:SYMBOLS_FOLDER_FROM_USER];
        [xmlWriter writeAttribute:@"prompt" value:IMAGECLASS_DEFAULTPROMPT];
        [xmlWriter writeAttribute:@"showname" value:[globalFuncs removeFilePrefix:sFilename prefixIs:PREFIX_USER_IMAGES]];
        [xmlWriter writeAttribute:@"type" value:IMAGECLASS_DEFAULTTYPE];
        
     }
    else{
        
        // the boardsList.xml exists.
//        if ([[sFilename pathExtension] isEqualToString:@"xml"])
//            sFilename = [sFilename stringByDeletingPathExtension];
//        
//        
//        [xmlWriter writeAttribute:@"id" value:[NSString stringWithFormat:@"0"]];
//        [xmlWriter writeAttribute:@"filename" value:[NSString stringWithFormat:@"%@",sFilename]];
//        // setting the warning icon indicates the somehow the boardlist.xml has been deleted
//        [xmlWriter writeAttribute:@"icon" value:@"warning.png"];
//        [xmlWriter writeAttribute:@"date" value:[NSString stringWithFormat:@"%@",[NSDate date]]];
//        //        NSData* dataBoardIcon = UIImageJPEGRepresentation([UIImage imageNamed:@"table_48x48.gif"], 1.0);
        //        NSString *byteArray  = [dataBoardIcon  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //        [xmlWriter writeAttribute:@"icon" value:byteArray];
        
    }
    
    [xmlWriter writeEndElement];
    
    return xmlWriter;
    
}

#pragma mark - IMAGES - Shared Funcs

-(XMLWriter*)createXMLEndwith:(XMLWriter*) xmlWriter
{
    // close root element
    [xmlWriter writeEndElement];
    
    // end document
    [xmlWriter writeEndDocument];
    
    return xmlWriter;
    
}







#pragma mark -
#pragma mark Handling BOARDS
#pragma mark -

#pragma mark Handle List of Boards

-(void)createBoardsList_fromBoardsFolder:(NSArray*) arrayfolderContents
{
    //this func is used when for some reason the boards_list.xml does not exists
    //in this case we list all the existing files in /library/boards and recreate the file
    
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    xmlWriter=[self createXMLheader:xmlWriter andwith:@"REcreated from folder list"];
    
    // add root element
    [xmlWriter writeStartElement:@"boards"];
    
    NSString* fileXML = @"";
    for (fileXML in arrayfolderContents)
    {
        xmlWriter=[self createBoardListXMLBodywith:xmlWriter with:nil andwithFilename:fileXML];
    }
    
    NSData* data  = [self createXMLEndwith:xmlWriter].toData;
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    NSString* dirLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dirBoards = [dirLibrary stringByAppendingPathComponent:BOARDS_MAIN_FOLDER];
    fileXML = [dirBoards stringByAppendingPathComponent:@"boards_list.xml"];
    
    [filemanager createDirectoryAtPath:dirBoards withIntermediateDirectories:YES attributes:nil error:nil];
    
    [data writeToFile:fileXML atomically:YES];
    
    // sent when the parser has completed parsing. If this is encountered, the parse was successful.
    NSLog(@"XML is DONE");

}

-(void)createBoardsList_localXMLfile:(NSString*)sComment andwith:(NSArray*)arraySourceData
{
    //id<XMLStreamWriter> xmlWriter = [[XMLWriter alloc]init];
    
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    xmlWriter=[self createXMLheader:xmlWriter andwith:sComment];
    
    // add root element
    [xmlWriter writeStartElement:@"boards"];
    
    
    for (brdRecords in arraySourceData)
    {
        xmlWriter=[self createBoardListXMLBodywith:xmlWriter with:brdRecords andwithFilename:nil];
    }
    
    NSData* data  = [self createXMLEndwith:xmlWriter].toData;
    
    NSString* fileXML;
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    NSString* dirLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dirBoards = [dirLibrary stringByAppendingPathComponent:BOARDS_MAIN_FOLDER];
    fileXML = [dirBoards stringByAppendingPathComponent:@"boards_list.xml"];
    
    [filemanager createDirectoryAtPath:dirBoards withIntermediateDirectories:YES attributes:nil error:nil];
    
    [data writeToFile:fileXML atomically:YES];
    
    // sent when the parser has completed parsing. If this is encountered, the parse was successful.
    NSLog(@"XML is DONE");
    
}

-(XMLWriter*)createBoardListXMLBodywith:(XMLWriter*) xmlWriter with:(BoardsList_class*)brdRecord andwithFilename:(NSString*)sFilename
{
    //sFilename is used when creating the list directly from the existing files
    
    // add element with an attribute and some some text
    [xmlWriter writeStartElement:@"board"];
    
    if (sFilename == nil) {
        
        
        if ([[brdRecord.brdFileName pathExtension] isEqualToString:@"xml"])
            brdRecord.brdFileName = [brdRecord.brdFileName stringByDeletingPathExtension];
        
        [xmlWriter writeAttribute:@"id" value:[NSString stringWithFormat:@"%d",brdRecord.brdID]];
        [xmlWriter writeAttribute:@"filename" value:[NSString stringWithFormat:@"%@",brdRecord.brdFileName]];
       
        [xmlWriter writeAttribute:@"icon" value:[NSString stringWithFormat:@"%@",brdRecord.brdIcon]];
        
        //  value:[NSString stringWithFormat:@"%@",brdRecord.brdIcon]];
        [xmlWriter writeAttribute:@"date" value:[NSString stringWithFormat:@"%@",brdRecord.brdDate]];
        
        
        //
        //    NSData* dataBoardIcon = UIImageJPEGRepresentation([UIImage imageNamed:@"table_48x48.gif"], 1.0);
        //    //    UIImage *image = [UIImage imageNamed:@"image.png"];
        //    //    NSData *data = UIImagePNGRepresentation(image);
        //    NSString *byteArray  = [dataBoardIcon  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //    [xmlWriter writeAttribute:@"icon" value:byteArray];
        
    }
    else{
        
        // the boardsList.xml exists.
        if ([[sFilename pathExtension] isEqualToString:@"xml"])
            sFilename = [sFilename stringByDeletingPathExtension];
        
        
        [xmlWriter writeAttribute:@"id" value:[NSString stringWithFormat:@"0"]];
        [xmlWriter writeAttribute:@"filename" value:[NSString stringWithFormat:@"%@",sFilename]];
         // setting the warning icon indicates the somehow the boardlist.xml has been deleted
        [xmlWriter writeAttribute:@"icon" value:@"warning.png"];
        [xmlWriter writeAttribute:@"date" value:[NSString stringWithFormat:@"%@",[NSDate date]]];
//        NSData* dataBoardIcon = UIImageJPEGRepresentation([UIImage imageNamed:@"table_48x48.gif"], 1.0);
//        NSString *byteArray  = [dataBoardIcon  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        [xmlWriter writeAttribute:@"icon" value:byteArray];
        
    }
    
    [xmlWriter writeEndElement];
    
    return xmlWriter;
    
}


#pragma mark Handle Save Board+Cells



-(void)createBoardLocalXMLfilewithComment:(NSString*)sComment withData:(NSArray*)arraySourceData andwithBoardName:(NSString*)strBoardName
{
    
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    xmlWriter=[self createXMLheader:xmlWriter andwith:sComment];
    
    //create the XML data
    
    //check what type of item the arraySourceData contains
    for (id obj in arraySourceData)
    {  //if it's Board_class
        if ([obj isKindOfClass:[Board_class class]]) {
            Board_class* objBoard = (Board_class*)obj;
            xmlWriter=[self createBoardXMLBodywith:xmlWriter andwith:objBoard];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray* array = [[NSArray alloc]initWithArray:obj];
            for (Cell_class* cellX in array) {
                xmlWriter=[self createCellXMLBodywith:xmlWriter andwith:cellX];
            }
        }
        
//        //if it's Cell_class
//        if ([obj isKindOfClass:[Cell_class class]]) {
//            Cell_class* objCell = (Cell_class*)obj;
//            xmlWriter=[self createCellXMLBodywith:xmlWriter andwith:objCell];
//        }

    }
    
    xmlWriter=[self createXMLEndwith:xmlWriter];
    
    NSData* data  = xmlWriter.toData;
   // [self createXMLEndwith:xmlWriter].toData;
    
   //board name is the filename to save the board as
    NSString* fileXML;
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    NSString* dirLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dirMainSymbols = [dirLibrary stringByAppendingPathComponent:BOARDS_MAIN_FOLDER];
    NSString* saveBoardAs =[NSString stringWithFormat:@"%@.xml",strBoardName];
    
    fileXML = [dirMainSymbols stringByAppendingPathComponent:saveBoardAs];
    
    [filemanager createDirectoryAtPath:dirMainSymbols withIntermediateDirectories:YES attributes:nil error:nil];
    
    [data writeToFile:fileXML atomically:YES];
    
    // sent when the parser has completed parsing. If this is encountered, the parse was successful.
    NSLog(@"Board %@ has been saved",strBoardName);
    
}


-(XMLWriter*)createBoardXMLBodywith:(XMLWriter*) xmlWriter andwith:(Board_class*)currBoard
{
    
    // add element with an attribute and some some text
    [xmlWriter writeStartElement:@"board"];
    [xmlWriter writeAttribute:@"index" value:[NSString stringWithFormat:@"%d",currBoard.brdID]];
    [xmlWriter writeAttribute:@"name" value:[NSString stringWithFormat:@"%@",currBoard.brdName]];
    [xmlWriter writeAttribute:@"user_id" value:[NSString stringWithFormat:@"%d",currBoard.brdUserID]];
    [xmlWriter writeAttribute:@"columns" value:[NSString stringWithFormat:@"%@",currBoard.brdCols]];
    [xmlWriter writeAttribute:@"rows" value:[NSString stringWithFormat:@"%@",currBoard.brdRows]];
    [xmlWriter writeAttribute:@"createdby" value:[NSString stringWithFormat:@"%@",currBoard.brdCreatedBy]];
    [xmlWriter writeAttribute:@"createddate" value:[NSString stringWithFormat:@"%@",currBoard.brdCreatedDate]];
    [xmlWriter writeAttribute:@"lastupdatedby" value:[NSString stringWithFormat:@"%@",currBoard.brdLastUpdatedBy]];
    [xmlWriter writeAttribute:@"lastupdateddate" value:[NSString stringWithFormat:@"%@",currBoard.brdLastUpdateDate]];
    
    

//    [xmlWriter writeStartElement:@"name"];
//    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",currBoard.brdName]];
//    [xmlWriter writeEndElement:@"name"];
//    [xmlWriter writeStartElement:@"user_id"];
//    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%d",currBoard.brdUserID]];
//    [xmlWriter writeEndElement:@"user_id"];
//    [xmlWriter writeStartElement:@"columns"];
//    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",currBoard.brdCols]];
//    [xmlWriter writeEndElement:@"columns"];
//    [xmlWriter writeStartElement:@"rows"];
//    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",currBoard.brdRows]];
//    [xmlWriter writeEndElement:@"rows"];
//    [xmlWriter writeStartElement:@"createdby"];
//    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",currBoard.brdCreatedBy]];
//    [xmlWriter writeEndElement:@"createdby"];
//    [xmlWriter writeStartElement:@"createddate"];
//    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",currBoard.brdCreatedDate]];
//    [xmlWriter writeEndElement:@"createddate"];
//    [xmlWriter writeStartElement:@"lastupdatedby"];
//    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",currBoard.brdLastUpdatedBy]];
//    [xmlWriter writeEndElement:@"lastupdatedby"];
//    [xmlWriter writeStartElement:@"lastupdateddate"];
//    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@",currBoard.brdLastUpdateDate]];
//    [xmlWriter writeEndElement:@"lastupdateddate"];
    
    [xmlWriter writeEndElement:@"board"];
    return xmlWriter;
    
}


-(XMLWriter*)createCellXMLBodywith:(XMLWriter*) xmlWriter andwith:(Cell_class*)currCell
{
    
    globalFuncs = [[GlobalsFunctions_class alloc]init];
    
    // add element with an attribute and some some text
    [xmlWriter writeStartElement:@"cell"];
    [xmlWriter writeAttribute:@"index" value:[NSString stringWithFormat:@"%d",currCell.cellIndex]];
    [xmlWriter writeAttribute:@"board_id" value:[NSString stringWithFormat:@"%d",currCell.cellBoardID]];
    [xmlWriter writeAttribute:@"image_id" value:[NSString stringWithFormat:@"%@",currCell.cellImageID]];
    [xmlWriter writeAttribute:@"image_row" value:[NSString stringWithFormat:@"%d",currCell.cellImageRow]];
    [xmlWriter writeAttribute:@"image_col" value:[NSString stringWithFormat:@"%d",currCell.cellImageCol]];
    [xmlWriter writeAttribute:@"text" value:currCell.cellText];
    [xmlWriter writeAttribute:@"textontop" value:[NSString stringWithFormat:@"%d",currCell.cellTextOnTop]];
    [xmlWriter writeAttribute:@"hidden" value:[NSString stringWithFormat:@"%d",currCell.cellHidden]];
    
    [xmlWriter writeAttribute:@"font" value:[NSString stringWithFormat:@"%@",currCell.cellFont]];
    NSArray* arrayFontColor = [globalFuncs Color2RGB:currCell.cellFontColor];
    NSString* strFontColor = [globalFuncs RGB2String:arrayFontColor];
    [xmlWriter writeAttribute:@"font_color" value:[NSString stringWithFormat:@"%@",strFontColor]];
    [xmlWriter writeAttribute:@"font_size" value:[NSString stringWithFormat:@"%f",currCell.cellFontSize]];
    [xmlWriter writeAttribute:@"font_type" value:[NSString stringWithFormat:@"%d",currCell.cellFontType]];
    
     NSArray* arrayBackgroundColor = [globalFuncs Color2RGB:currCell.cellBackgroundColor];
     NSString* strBackgroundColor = [globalFuncs RGB2String:arrayBackgroundColor];
    [xmlWriter writeAttribute:@"background_color" value:[NSString stringWithFormat:@"%@",strBackgroundColor]];
   
    NSArray* arrayBorderColor = [globalFuncs Color2RGB:currCell.cellBorderColor];
    NSString* strBorderColor = [globalFuncs RGB2String:arrayBorderColor];
    [xmlWriter writeAttribute:@"border_color" value:[NSString stringWithFormat:@"%@",strBorderColor]];
    [xmlWriter writeAttribute:@"border_width" value:[NSString stringWithFormat:@"%d",(int)currCell.cellBorderWidth]];
    [xmlWriter writeAttribute:@"message" value:[NSString stringWithFormat:@"%@",currCell.cellMessage]];
    
    [xmlWriter writeAttribute:@"sound_filename" value:[NSString stringWithFormat:@"%@",currCell.cellSoundFilename]];
    [xmlWriter writeAttribute:@"sound_path" value:[NSString stringWithFormat:@"%@",currCell.cellSoundPath]];
    [xmlWriter writeAttribute:@"MP3_path" value:[NSString stringWithFormat:@"%@",currCell.cellMP3Path]];
    [xmlWriter writeAttribute:@"video_path" value:[NSString stringWithFormat:@"%@",currCell.cellVIDEOPath]];
    [xmlWriter writeAttribute:@"web_path" value:[NSString stringWithFormat:@"%@",currCell.cellWEBPath]];
    [xmlWriter writeAttribute:@"link2board" value:[NSString stringWithFormat:@"%d",currCell.cellBoardLink]];

    [xmlWriter writeAttribute:@"buttonPlay_enabled" value:[NSString stringWithFormat:@"%d",currCell.cellBtnPlayIsEnabled]];
    [xmlWriter writeAttribute:@"width" value:[NSString stringWithFormat:@"%.2f",currCell.size.width]];
    [xmlWriter writeAttribute:@"height" value:[NSString stringWithFormat:@"%.2f",currCell.size.height]];
    [xmlWriter writeAttribute:@"x" value:[NSString stringWithFormat:@"%.2f",currCell.coordinates.x]];
    [xmlWriter writeAttribute:@"y" value:[NSString stringWithFormat:@"%.2f",currCell.coordinates.y]];
   // [xmlWriter writeAttribute:@"tag" value:[NSString stringWithFormat:@"%@",currCell.tag]];
    
  
    NSMutableArray* arrayCollection=[[NSMutableArray alloc]init];
    NSString* strCollection = @"";
    
    for (int i=0; i<currCell.collection.count; i++) {
     
        NSValue* valueX = [currCell.collection objectAtIndex:i];
        NSString* str = [NSString stringWithFormat:@"%.0f",valueX.CGPointValue.x];
        str = [str stringByAppendingFormat:@",%.0f;",valueX.CGPointValue.y];
       
       // valueX.CGPointValue = CGPointMake(valueX, valueX.y);
       // NSString* s = [NSString stringWithFormat:@"%.0f,%.0f;",valueX.CGPointValue.x,valueX.CGPointValue.y];
        strCollection = [strCollection stringByAppendingString:str];
    }
    
    [xmlWriter writeAttribute:@"collection" value:[NSString stringWithFormat:@"%@",strCollection]];
    
    [xmlWriter writeAttribute:@"mark" value:[NSString stringWithFormat:@"%d",currCell.mark]];
    [xmlWriter writeAttribute:@"mark4show" value:[NSString stringWithFormat:@"%d",currCell.mark4show]];
    
    [xmlWriter writeAttribute:@"createdby" value:[NSString stringWithFormat:@"%@",currCell.cellCreatedBy]];
    [xmlWriter writeAttribute:@"createddate" value:[NSString stringWithFormat:@"%@",currCell.cellCreatedDate]];
    [xmlWriter writeAttribute:@"lastupdatedby" value:[NSString stringWithFormat:@"%@",currCell.cellLastUpdatedBy]];
    [xmlWriter writeAttribute:@"lastupdateddate" value:[NSString stringWithFormat:@"%@",currCell.cellLastUpdateDate]];
    
    
    
    //[xmlWriter writeCharacters:@"This element has an attribute"];
    [xmlWriter writeEndElement];
    
    return xmlWriter;
    
}


-(XMLWriter*)createXMLheader:(XMLWriter*) xmlWriter andwith:(NSString*) xmlComment
{
    // allocate serializer
    // id<XMLStreamWriter> xmlWriter = [[XMLWriter alloc]init];
    
    //will add an XML document header to the top of the XML document:
    //<?xml version="1.0" encoding="UTF-8"?>
    [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    
    //add comment
    [xmlWriter writeComment:xmlComment];
    
   //add root element
  [xmlWriter writeStartElement:@"details"];
    
    return xmlWriter;
    
}

#pragma mark -


#pragma mark Handle Load Board+Cells


-(id)loadBoardData:(BoardsList_class*)board4Loading
{
  //  NSError* error;
    NSString* fileXML;
    NSData* data;
    NSError* err;
    AppDelegate* appDelegate = DELEGATE;

    globalFuncs = [[GlobalsFunctions_class alloc]init];
    
  //  NSFileManager* filemanager = [NSFileManager defaultManager];
    NSString* dirLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dirBoards = [dirLibrary stringByAppendingPathComponent:BOARDS_MAIN_FOLDER];
    
    fileXML = [dirBoards stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",board4Loading.brdFileName]];
    fileXML = [fileXML stringByAppendingPathExtension:@"xml"];
    //check if board file exists
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileXML];
    
    if(fileExists)
    {
        
        //arrayOfNavigationStackBoards hold all the boards loaded by user so far
        [appDelegate.arrayOfNavigationStackBoards addObject:board4Loading];

        array4LoadedBoard = [[NSMutableArray alloc]init];
        array4MatrixRow = [[NSMutableArray alloc]init];
        cntCellsPerRow=0;
        
        data = [[NSData alloc]initWithContentsOfFile:fileXML options:NSDataReadingMappedIfSafe error:&err];
        NSLog(@"%@",err);
        
        parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate=self;
        
        [parser parse];
        
        //[array4LoadedBoard addObject:array4MatrixRow];
        
        appDelegate.arrayOfLoadedBoard = array4LoadedBoard;
        
        
        
    }
    
  
   
    return  self;

}


-(NSArray*)getRecordsAtDir:(NSString*) DirectoryPath
{
    
    NSArray* arrayTMP = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DirectoryPath error:NULL];
    // NSMutableArray *directoryContent = [NSMutableArray arrayWithArray:arrayTMP];
    
    return arrayTMP;
}



// read XML file after downloading it from server
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
   
    
    // download image to local dir and add data to Image_class
    if ([elementName isEqualToString:@"image"]) {
        
        // retrieve the name of the file from -imagelink-
        NSString* strFileLink = [attributeDict objectForKey:@"imagelink"];
        NSString* strFileName = [strFileLink lastPathComponent];
        NSString* strImageIndex=0;
        if ([packageName isEqualToString:@"WIDGIT"]) {
            // retrieve the index of image from its filename
            strImageIndex = [strFileName stringByDeletingPathExtension];
        }
        
        NSString* strName = [attributeDict objectForKey:@"showname"];
     
        //set the image local path
        NSString* strFullFilename= [path4SaveImages stringByAppendingPathComponent:strFileName];
        
        //retrieve the remote(server) path of the image
        NSURL* url = [NSURL URLWithString:[attributeDict objectForKey:@"imagelink"]];
        NSData* data = [NSData dataWithContentsOfURL:url];
        
        
        // save the image to local path
        UIImage* image = [UIImage imageWithData:data];
        NSData* imgdata = UIImagePNGRepresentation(image);
        
        [imgdata writeToFile:[LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:strFullFilename] atomically:YES];
        
        
        
        
        //add data to Images_class
        imgRecords = [[Images_class alloc]init];
        [imgRecords updateImageClasswithShowName:strName
                              andwithDescription:IMAGECLASS_DESCRIPTION
                                 andwithFileName:strFileName
         andwithPath:path4SaveImages // stringByAbbreviatingWithTildeInPath]
                                 andwithCategory:IMAGECLASS_DEFAULTCATEGORY
                              andwithUpdatedDate:[NSDate date]
                            andwithUpdatedDateby:IMAGECLASS_DEFAULTUSER
                                   andwithPrompt:IMAGECLASS_DEFAULTPROMPT
                                     andwithType:IMAGECLASS_DEFAULTTYPE
                                    andwithIndex:strImageIndex];
        
        imgRecords.imgCreatedBy = @"server";
        imgRecords.imgCreatedDate = [NSDate date];
        [arrayOfImagesRecords addObject:imgRecords];
        
        // update the main UI
        NSNumber* totFiles = [NSNumber numberWithInteger:arrayOfImagesRecords.count];
        NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
        [notificationcenter postNotificationName:@"updateprogress" object:totFiles] ;
        
 
    }
    
    // load board data
    if ([elementName isEqualToString:@"board"]) {
        Board_class* loadedBoard = [[Board_class alloc]init];

        loadedBoard.brdID = (int)[attributeDict objectForKey:@"index"];
        loadedBoard.brdName = [attributeDict objectForKey:@"name"];
        loadedBoard.brdUserID = (int)[attributeDict objectForKey:@"user_id"];
        loadedBoard.brdCols = [attributeDict objectForKey:@"columns"];
        loadedBoard.brdRows = [attributeDict objectForKey:@"rows"];
        loadedBoard.brdCreatedBy = [attributeDict objectForKey:@"createdby"];
        loadedBoard.brdCreatedDate = [attributeDict objectForKey:@"createddate"];
        loadedBoard.brdLastUpdatedBy = [attributeDict objectForKey:@"lastupdatedby"];
        loadedBoard.brdLastUpdateDate = [attributeDict objectForKey:@"lastupdateddate"];
        
        
        [array4LoadedBoard addObject:loadedBoard];
        
    }
    
    // load cells data
    if ([elementName isEqualToString:@"cell"]) {
        
        
        Cell_class* loadedCell = [[Cell_class alloc]init];
        // retrieve the cells
       
        loadedCell.cellIndex = [[attributeDict objectForKey:@"index"] intValue];
        loadedCell.cellBoardID = [[attributeDict objectForKey:@"board_id"] intValue];
        loadedCell.cellImageID  = [attributeDict objectForKey:@"image_id"];
        
        
        loadedCell.cellImageRow = [[attributeDict objectForKey:@"image_row"] intValue];
        loadedCell.cellImageCol = [[attributeDict objectForKey:@"image_col"] intValue];
        loadedCell.cellText = [attributeDict objectForKey:@"text"];
        loadedCell.cellTextOnTop = [[attributeDict objectForKey:@"textontop"] boolValue];
        loadedCell.cellHidden = [[attributeDict objectForKey:@"hidden"] boolValue];
        
        loadedCell.cellFont = [attributeDict objectForKey:@"font"];
        NSString* strFontColor = [attributeDict objectForKey:@"font_color"];
        loadedCell.cellFontColor = [globalFuncs RGB2Color:strFontColor];
        loadedCell.cellFontSize = [[attributeDict objectForKey:@"font_size"] intValue];
        loadedCell.cellFontType = [[attributeDict objectForKey:@"font_type"] intValue];

        
        NSString* strBackgroundColor = [attributeDict objectForKey:@"background_color"];
        loadedCell.cellBackgroundColor = [globalFuncs RGB2Color:strBackgroundColor];
        
        
        NSString* strBorderColor = [attributeDict objectForKey:@"border_color"];
        loadedCell.cellBorderColor = [globalFuncs RGB2Color:strBorderColor];
        loadedCell.cellBorderWidth = [[attributeDict objectForKey:@"border_width"] intValue];
       
        
        loadedCell.cellSoundFilename = [attributeDict objectForKey:@"sound_filename"];
        if ([loadedCell.cellSoundFilename isEqual:@"(null)"]) {
            loadedCell.cellSoundFilename = @"";
        }
        
        loadedCell.cellSoundPath = [attributeDict objectForKey:@"sound_path"];
        if ([loadedCell.cellSoundPath isEqual:@"(null)"]) {
            loadedCell.cellSoundPath = @"";
        }

        loadedCell.cellMessage = [attributeDict objectForKey:@"message"];
        
        
        loadedCell.cellMP3Path = [attributeDict objectForKey:@"MP3_path"];
        if ([loadedCell.cellMP3Path isEqual:@"(null)"]) {
            loadedCell.cellMP3Path = @"";
        }

        loadedCell.cellVIDEOPath = [attributeDict objectForKey:@"video_path"];
        if ([loadedCell.cellVIDEOPath isEqual:@"(null)"]) {
            loadedCell.cellVIDEOPath = @"";
        }

        loadedCell.cellWEBPath = [attributeDict objectForKey:@"web_path"];
        if ([loadedCell.cellWEBPath isEqual:@"(null)"]) {
            loadedCell.cellWEBPath = @"";
        }

        loadedCell.cellBoardLink = [[attributeDict objectForKey:@"link2board"] intValue];
        loadedCell.cellBtnPlayIsEnabled = [attributeDict objectForKey:@"buttonPlay_enabled"];
        
        float H = [[attributeDict objectForKey:@"height"] floatValue];
        float W = [[attributeDict objectForKey:@"width"] floatValue];
        loadedCell.size = CGSizeMake(W, H);
        
        float X = [[attributeDict objectForKey:@"x"] floatValue];
        float Y = [[attributeDict objectForKey:@"y"] floatValue];
        loadedCell.coordinates = CGPointMake(X, Y);
        
       // loadedCell.tag = [attributeDict objectForKey:@"tag"]
            
        NSString* strCollection = [attributeDict objectForKey:@"collection"];
        NSArray* arrayCollection = [[NSArray alloc]init];
        
        arrayCollection = [strCollection componentsSeparatedByString:@";"];
        for (int i=0; i<arrayCollection.count; i++) {
            
            NSString* strItem = [NSString stringWithFormat:@"%@",[arrayCollection objectAtIndex:i]];
            if (![strItem isEqualToString:@""]) {
                NSArray* arrayTMP = [[NSArray alloc]init];
                arrayTMP = [strItem componentsSeparatedByString:@","];
                
                CGPoint pointX = CGPointMake([[arrayTMP objectAtIndex:0] floatValue], [[arrayTMP objectAtIndex:1] floatValue]);
                
                NSValue* valueX = [NSValue valueWithCGPoint:pointX];
                
                [loadedCell.collection addObject:valueX];

            }
            
        }
        
        loadedCell.mark = [[attributeDict objectForKey:@"mark"] boolValue];
        loadedCell.mark4show = [[attributeDict objectForKey:@"mark4show"] boolValue];
        loadedCell.cellCreatedBy = [attributeDict objectForKey:@"createdby"];
        if ([loadedCell.cellCreatedBy isEqual:@"(null)"]) {
            loadedCell.cellCreatedBy = @"";
        }

        loadedCell.cellCreatedDate = [attributeDict objectForKey:@"createddate"];
        loadedCell.cellLastUpdatedBy = [attributeDict objectForKey:@"lastupdatedby"];
        if ([loadedCell.cellLastUpdatedBy isEqual:@"(null)"]) {
            loadedCell.cellLastUpdatedBy = @"";
        }

        loadedCell.cellLastUpdateDate = [attributeDict objectForKey:@"lastupdateddate"];
        
        [array4MatrixRow addObject:loadedCell];
        if (array4MatrixRow.count == 12) {
            
            NSArray* arrayTMP = [[NSArray alloc]initWithArray:array4MatrixRow copyItems:YES];
            [array4LoadedBoard addObject:arrayTMP];
          
            [array4MatrixRow removeAllObjects];
            
          
        }

        
    }
    
}

//after downloading images from server, create local xml with images data
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    NSLog(@"parsing file from server - DONE");
    
    if (arrayOfImagesRecords != nil) {
        //create local XML file from imgRecords
        [self createImagesLocalXMLfile:packageName andwith:arrayOfImagesRecords];

    }
    
}


@end
