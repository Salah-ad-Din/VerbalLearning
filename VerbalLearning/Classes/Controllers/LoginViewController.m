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

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *orgSelectButton;
@property (weak, nonatomic) IBOutlet UITableView *orgSelectTableView;

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
        if (parser.errorMsg) {
            //登录成功
            
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
        if (_orgSelectTableView.frame.size.height > 100) {
            CGRect rect = _orgSelectTableView.frame;
            rect.size.height = 0.0f;
            _orgSelectTableView.frame = rect;
        } else {
            CGRect rect = _orgSelectTableView.frame;
            rect.size.height = 193.0f;
            _orgSelectTableView.frame = rect;
        }
    } completion:^(BOOL finished) {
    
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrgSelectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    return cell;
}

@end
