//
//  Popover_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 12/18/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import "Popover_viewcontroller.h"

@interface Popover_viewcontroller () <UITextFieldDelegate>
@property UIImageView* imgView;
@property UITextField* txtField;
@property UISwitch* swtOptions;
@property UILabel* lblSwitchDescr;
@property UIToolbar* toolbarMenu;
@property CGSize viewSize;
@property CGPoint viewPoint;
@property NSArray* arrayNotificationParam;
@end

@implementation Popover_viewcontroller
@synthesize viewType,viewObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _imgView = [[UIImageView alloc]init];
    [self.view addSubview:_imgView];
    _txtField = [[UITextField alloc]init];
    _txtField.delegate = self;
    [self.view addSubview:_txtField];
    _lblSwitchDescr = [[UILabel alloc]init];
    [self.view addSubview:_lblSwitchDescr];
    _swtOptions = [[UISwitch alloc]init];
    [self.view addSubview:_swtOptions];
    _toolbarMenu = [[UIToolbar alloc]init];
    [self.view addSubview:_toolbarMenu];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //todo create DONE and CANCEL selectors
    //todo delete the NEXT navigation controller
    
    _viewSize = self.view.frame.size;
    UIBarButtonItem* btnItemDone = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didUserDone)];
    
    UIBarButtonItem* btnItemCancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didUserCancel)];
    
    UIBarButtonItem* btnItemFlexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    _toolbarMenu.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:btnItemDone];
    [items addObject:btnItemFlexible];
    [items addObject:btnItemCancel];
    [_toolbarMenu setItems:items animated:NO];
    

    
    
    
    [self loadObjects];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark MISC Functions
#pragma mark -

-(void)loadObjects
{
    switch (viewType) {
        case 0: //newboard objects - load from main screen
        //imgView - image of the selected new board type
        //txtField - name for the new board
        {
            UIImage* imgX = [[UIImage alloc]init];
            imgX = (UIImage*)viewObject;
            [_imgView setImage:imgX];
            _viewSize = self.view.frame.size;
            [_imgView setFrame:CGRectMake((_viewSize.width - 150)/2, _toolbarMenu.frame.origin.y + _toolbarMenu.frame.size.height + 20, 150, 120)];
            
            [_txtField setFrame:CGRectMake(10, _imgView.frame.origin.y + _imgView.frame.size.height+15, _viewSize.width-40, 30)];
            _txtField.placeholder = @" Enter name of board";
            _txtField.layer.borderWidth = 2.0f;
            _txtField.layer.borderColor = [UIColor blueColor].CGColor;
            _txtField.layer.cornerRadius = 5.0f;

            
            
            [_lblSwitchDescr setText:@"Set main board"];
            [_lblSwitchDescr setFrame:CGRectMake(_txtField.frame.origin.x, _txtField.frame.origin.y+_txtField.frame.size.height+10, 150, 30)];

            [_swtOptions setFrame:CGRectMake(_lblSwitchDescr.frame.origin.x + _lblSwitchDescr.frame.size.width+5, _lblSwitchDescr.frame.origin.y,_swtOptions.frame.size.width, _swtOptions.frame.size.height)];
            
            break;
        }
        default:
            break;
    }
}

-(void)didUserDone
{
    switch (viewType) {
        case 0: //newboard objects - load from main screen
        {
            _arrayNotificationParam = [[NSArray alloc]initWithObjects:_txtField,_swtOptions, nil];
            NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
            
            [notificationcenter postNotificationName:@"dismisspopover" object:nil];
            [notificationcenter postNotificationName:@"userDidChooseNewBoard" object:_arrayNotificationParam];
           
            break;
        }
        default:
            break;
    }

}

-(void)didUserCancel
{
    switch (viewType) {
        case 0: //newboard objects - load from main screen
        {
          
            NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
           [notificationcenter postNotificationName:@"dismisspopover" object:nil];

            break;
        }
        default:
            break;
    }

    
}

#pragma mark DELEGATES

- (BOOL)textFieldShouldReturn:(UITextField *)textField             // called when 'return' key pressed. return
{
//    switch (viewType) {
//        case 0: //newboard objects - load from main screen
//        {
//            [textField resignFirstResponder];
//                       
//            break;
//        }
//        default:
//            break;
//    }
    [textField resignFirstResponder];
    return TRUE;
 
}
@end
