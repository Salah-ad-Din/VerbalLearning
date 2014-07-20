//
//  LoginViewController.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-7-15.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "LoginXMLParser.h"

#define ORGSELECT_CELL_HEIGHT               40.0f

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *orgSelectButton;
@property (weak, nonatomic) IBOutlet UITableView *orgSelectTableView;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (strong, nonatomic) NSMutableArray *orgInfoMArray;

@end

@implementation LoginViewController

@synthesize loginButton = _loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_loginButton.layer setCornerRadius:5.0];
    _orgSelectTableView.layer.borderWidth = 1.0f;
    _orgSelectTableView.layer.borderColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1].CGColor;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.isayb.com/index.php"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation =[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LoginXMLParser *parser = [[LoginXMLParser alloc] initWithXMLData:responseObject];
        if (parser.errorMsg == nil) {
            //登录成功
            
            _ipLabel.text = [NSString stringWithFormat:@"您的ip地址为：%@",parser.localIP];
            _orgInfoMArray = parser.orgInfoMArray;
            [_orgSelectTableView reloadData];
            
            [self orgSelectTableViewAnimation];
        } else {
            //机构过期或其他错误
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //网络错误
        
    }];
    [manager.operationQueue addOperation:operation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)orgSelectButtonPressed:(id)sender {
    [self orgSelectTableViewAnimation];
}

- (void)orgSelectTableViewAnimation
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (_orgSelectTableView.frame.size.height > 1.0f) {
            CGRect rect = _orgSelectTableView.frame;
            rect.size.height = 0.0f;
            _orgSelectTableView.frame = rect;
        } else {
            CGRect rect = _orgSelectTableView.frame;
            if (_orgInfoMArray != nil) {
                if ([_orgInfoMArray count] > 4) {
                    rect.size.height = ORGSELECT_CELL_HEIGHT * 4;
                } else {
                    rect.size.height = ORGSELECT_CELL_HEIGHT * [_orgInfoMArray count];
                }
            } else {
                rect.size.height = 0.0f;
            }
            _orgSelectTableView.frame = rect;
        }
    } completion:^(BOOL finished) {
    
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_orgInfoMArray == nil) {
        return 1;
    } else {
        return [_orgInfoMArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrgSelectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (_orgInfoMArray != nil) {
        OrgInfo *info = _orgInfoMArray[indexPath.row];
        cell.textLabel.text = info.orgName;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ORGSELECT_CELL_HEIGHT;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self orgSelectTableViewAnimation];
    NSString *orgName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [_orgSelectButton setTitle:orgName forState:UIControlStateNormal];
}

@end
