//
//  ImageList_TableViewCell.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 21/5/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "ImageList_TableViewCell.h"

@implementation ImageList_TableViewCell
@synthesize lblImageShowName,imgSymbol;

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        imgSymbol = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 32, 32)];
        lblImageShowName = [[UILabel alloc] initWithFrame:CGRectMake(52, 55, 200, 20)];
        lblImageShowName.textAlignment = NSTextAlignmentLeft;
        lblImageShowName.font = [UIFont systemFontOfSize:12];
      
       // self.descriptionLabel.textColor = [UIColor blackColor];
       // self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        [self addSubview:lblImageShowName];
        [self addSubview:imgSymbol];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
   // NSLog(lblImageShowName.text);
   // frame= CGRectMake(boundsX+10 ,0, 50, 50);
  //  imgSymbol.frame = frame;
    
  
}
@end
