//
//  LoginViewController.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-7-15.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "LoginViewController.h"
#import "VLSingleton.h"

#define ORGSELECT_CELL_HEIGHT               40.0f

typedef enum {
    XML_TYPE_RECOMMEND = 0,
    XML_TYPE_INTENSIVE,
    XML_TYPE_EXTENSIVE,
    XML_TYPE_DAILY
} XML_TYPE;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *orgSelectButton;
@property (weak, nonatomic) IBOutlet UITableView *orgSelectTableView;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (strong, nonatomic) LoginXMLParser *parser;


@end

@implementation LoginViewController

@synthesize loginButton = _loginButton;

static LoginViewController *rootViewController;
+ (LoginViewController *) rootViewController {
    if (rootViewController == nil) {
        rootViewController = [[LoginViewController alloc] init];
    }
    return rootViewController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rootViewController = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_loginButton.layer setCornerRadius:5.0];
    _orgSelectTableView.layer.borderWidth = 1.0f;
    _orgSelectTableView.layer.borderColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1].CGColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.isayb.com/index.php"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation =[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LoginXMLParser *parser = [[LoginXMLParser alloc] initWithXMLData:responseObject];
        self.parser = parser;
        if (parser.errorMsg == nil) {
            //刷新登录界面信息
            _ipLabel.text = [NSString stringWithFormat:@"您的ip地址为：%@",parser.localIP];
            _orgInfoMArray = parser.orgInfoMArray;
            _selectRecommendInfo = parser.recommendInfo;
            _selectIntensiveInfo = parser.intensiveInfo;
            _selectExtensiveInfo = parser.extensiveInfo;
            [_orgSelectTableView reloadData];
            [self orgSelectTableViewAnimation];
        } else {
            //机构过期或其他错误
        }
        
        //下载每日一句XML
        [self downloadDailyXMLCompletion:^{
            
        }];
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
    _selectOrgInfo = _orgInfoMArray[indexPath.row];
}

#pragma mark - login
- (IBAction)login:(id)sender {
    if (_selectOrgInfo) {
        
        void (^successBlock)(void) = ^{
            CenterDrawerViewController *centerViewController = [[CenterDrawerViewController alloc] init];
            LeftSideDrawerViewController *leftViewController = [[LeftSideDrawerViewController alloc] init];
            HomeDrawerViewController *homeViewController = [[HomeDrawerViewController alloc] initWithCenterViewController:centerViewController leftDrawerViewController:leftViewController];
            [homeViewController setShowsShadow:YES];
            [homeViewController setMaximumLeftDrawerWidth:280.0];
            [homeViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [homeViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            [self.navigationController pushViewController:homeViewController animated:YES];
        };
        
        //查询机构信息
        DatabaseOperation *dataBase = [DatabaseOperation database];
        OrgInfo *info = [dataBase selectOrgInfoWithOrgID:_selectOrgInfo.orgID];
        if (info) {
            //与本地数据库对比xml的md5
            [self updateXMLVersionWithUpdateType:XML_TYPE_RECOMMEND completion:^{
                [self updateXMLVersionWithUpdateType:XML_TYPE_EXTENSIVE completion:^{
                    [self updateXMLVersionWithUpdateType:XML_TYPE_INTENSIVE completion:^{
                        successBlock();
                    }];
                }];
            }];
        } else {
            //插入机构信息
            [dataBase insertOrgInfo:_selectOrgInfo];
            [self insertXMLVersionWithRecommendMD5:_selectRecommendInfo.expireMD5 intensiveMD5:_selectIntensiveInfo.expireMD5 extensiveMD5:_selectExtensiveInfo.expireMD5 withOrgID:_selectOrgInfo.orgID completion:^{
                successBlock();
            }];
            
        }
    }
}

- (void)insertXMLVersionWithRecommendMD5:(NSString *)recommendMD5
                            intensiveMD5:(NSString *)intensiveMD5
                            extensiveMD5:(NSString *)extensiveMD5
                               withOrgID:(NSInteger)orgID
                              completion:(void (^)(void))completion
{
    [self downloadXMLWithXMLType:XML_TYPE_RECOMMEND completion:^{
       [self downloadXMLWithXMLType:XML_TYPE_EXTENSIVE completion:^{
           [self downloadXMLWithXMLType:XML_TYPE_INTENSIVE completion:^{
               
               DatabaseOperation *dataBase = [DatabaseOperation database];
               [dataBase insertRecommendMD5:recommendMD5 intensiveMD5:intensiveMD5 extensiveMD5:extensiveMD5 withOrgID:orgID];
               completion();
           }];
       }];
    }];

    
}

- (void)updateXMLVersionWithUpdateType:(XML_TYPE)type completion:(void (^)(void))completion
{
    NSString *md5InDatabase = nil;
    BOOL needUpdate = NO;
    DatabaseOperation *dataBase = [DatabaseOperation database];
    switch (type) {
        case XML_TYPE_RECOMMEND:
            md5InDatabase = [dataBase selectRecommendMD5WithOrgID:_selectOrgInfo.orgID];
            if (![md5InDatabase isEqualToString:_selectRecommendInfo.expireMD5]) {
                needUpdate = YES;
            }
            break;
        case XML_TYPE_INTENSIVE:
            md5InDatabase = [dataBase selectIntensiveMD5WithOrgID:_selectOrgInfo.orgID];
            if (![md5InDatabase isEqualToString:_selectIntensiveInfo.expireMD5]) {
                needUpdate = YES;
            }
            break;
        case XML_TYPE_EXTENSIVE:
            md5InDatabase = [dataBase selectExtensiveMD5WithOrgID:_selectOrgInfo.orgID];
            if (![md5InDatabase isEqualToString:_selectExtensiveInfo.expireMD5]) {
                needUpdate = YES;
            }
            break;
        default:
            break;
    }
    
    if (needUpdate) {
        [self downloadXMLWithXMLType:type completion:^{
            //更新数据库xml版本
            [dataBase updateRecommendMD5:_selectRecommendInfo.expireMD5 withOrgID:_selectOrgInfo.orgID];
            completion();
        }];
    } else {
        completion();
    }
}

- (void)downloadXMLWithXMLType:(XML_TYPE)type completion:(void (^)(void))completion
{
    NSString *xmlString = nil;
    switch (type) {
        case XML_TYPE_RECOMMEND:
            xmlString = @"recommend.xml";
            break;
        case XML_TYPE_INTENSIVE:
            xmlString = @"intensive.xml";
            break;
        case XML_TYPE_EXTENSIVE:
            xmlString = @"extensive.xml";
        default:
            break;
    }
    
    //保存xml文件
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RESOURCE_BASE_URL,xmlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSProgress *progress;
    //保存在cache目录下
    NSString *downDir = [[VLSingleton sharedInstance] getCachePath];
    downDir = [downDir stringByAppendingString:[NSString stringWithFormat:@"/%ld",(long)_selectOrgInfo.orgID]];
    //创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:downDir isDirectory:NO]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:downDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //下载XML
    NSString *xmlSavePath = [downDir stringByAppendingString:[NSString stringWithFormat:@"/%@",xmlString]];
    [[AFHTTPSessionManager manager] setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    NSURLSessionDownloadTask * downloadTask = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //保存XML文件
        NSURL *filePath = [NSURL fileURLWithPath:xmlSavePath isDirectory:NO];
        //先删除一遍
        [[NSFileManager defaultManager] removeItemAtPath:[filePath path] error:nil];
        return filePath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error == nil) {
            completion();
        } else {
            
        }
    }];
    [downloadTask resume];

}

- (void)downloadDailyXMLCompletion:(void (^)(void))completion
{
    //保存xml文件
    NSURL *url = [NSURL URLWithString:self.parser.dailyURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSProgress *progress;
    //保存在cache目录下
    NSString *downDir = [[VLSingleton sharedInstance] getCachePath];
    /*
    downDir = [downDir stringByAppendingString:[NSString stringWithFormat:@"/%ld",(long)_selectOrgInfo.orgID]];
    //创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:downDir isDirectory:NO]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:downDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
     */
    //下载XML
    NSString *xmlSavePath = [downDir stringByAppendingString:@"/daily.xml"];
    [[AFHTTPSessionManager manager] setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    NSURLSessionDownloadTask * downloadTask = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //保存XML文件
        NSURL *filePath = [NSURL fileURLWithPath:xmlSavePath isDirectory:NO];
        //先删除一遍
        [[NSFileManager defaultManager] removeItemAtPath:[filePath path] error:nil];
        return filePath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error == nil) {
            completion();
        } else {
            
        }
    }];
    [downloadTask resume];
    
}

@end
