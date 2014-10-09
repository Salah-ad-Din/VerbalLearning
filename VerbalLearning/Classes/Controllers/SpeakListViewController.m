//
//  SpeakListViewController.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-3.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "SpeakListViewController.h"
#import "StoreVoiceDataListParser.h"
#import "UIImageView+AFNetworking.h"
#import "VoicePkgInfoObject.h"
#import "SpeakListTableViewCell.h"
#import "SpeakDetailListViewController.h"
#import "AHKActionSheet.h"
#import "VLSingleton.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "CourseParser.h"

@interface SpeakListViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) StoreVoiceDataListParser *parser;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *speakListTableView;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;
@property (strong, nonatomic) NSMutableArray *tableViewData;
@end

@implementation SpeakListViewController

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
    _orgNameLabel.text = [LoginViewController rootViewController].selectOrgInfo.orgName;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backToPrevios:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setXmlURL:(NSString *)xmlURL
{
    _xmlURL = xmlURL;
    StoreVoiceDataListParser *parser = [[StoreVoiceDataListParser alloc] init];
    NSData* filedata = [NSData dataWithContentsOfFile:xmlURL];
    [parser loadWithPkgData:filedata];
    self.parser = parser;
    
    self.tableViewData = [[NSMutableArray alloc] initWithCapacity:0];
    [self.tableViewData addObjectsFromArray:self.parser.pkgsArray];
//    for (id obj in parser.pkgsArray) {
//        [self.tableViewData addObject:parser.pkgsArray];
//    }
}

- (void)downloadResourceXML:(NSString *)URL withSavePath:(NSString *)savePath Completion:(void (^)(void))completion
{
    //保存xml文件
    NSURL *url = [NSURL URLWithString:URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSProgress *progress;
    //下载XML
    [[AFHTTPSessionManager manager] setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    NSURLSessionDownloadTask * downloadTask = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //保存XML文件
        NSURL *filePath = [NSURL fileURLWithPath:savePath isDirectory:NO];
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

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:nil];
    
    actionSheet.blurTintColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    actionSheet.blurRadius = 8.0f;
    actionSheet.buttonHeight = 50.0f;
    actionSheet.cancelButtonHeight = 50.0f;
    actionSheet.animationDuration = 0.5f;
    actionSheet.cancelButtonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    actionSheet.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    actionSheet.selectedBackgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    UIFont *defaultFont = [UIFont fontWithName:@"Avenir" size:17.0f];
    
    actionSheet.buttonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                          NSForegroundColorAttributeName : [UIColor whiteColor] };
    actionSheet.cancelButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                NSForegroundColorAttributeName : [UIColor whiteColor] };
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = [self.parser.pkgsArray[indexPath.row] title];

    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont fontWithName:@"Avenir" size:17.0f];
    label1.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label1];
    
    actionSheet.headerView = headerView;
    
    NSInteger count = 0;
    count = [[self.parser.pkgsArray[indexPath.row] dataPkgCourseInfoArray] count];


    
    for (int i = 0; i < count; i++) {
        //选择block
        void(^AHKActionSheetHandler)(AHKActionSheet *actionSheet) = ^(AHKActionSheet *actionSheet){
            NSString *xmlFileName = [[[self.parser.pkgsArray[indexPath.row] dataPkgCourseInfoArray] objectAtIndex:i] file];
            NSString *dowloadURL = [RESOURCE_BASE_URL stringByAppendingString:xmlFileName];
            
            NSString *saveDocument = [[VLSingleton sharedInstance] getCachePath];
            saveDocument = [saveDocument stringByAppendingString:[NSString stringWithFormat:@"/%ld/",(long)[LoginViewController rootViewController].selectOrgInfo.orgID]];
            NSString *savePath = [saveDocument stringByAppendingString:xmlFileName];
            
            [self downloadResourceXML:dowloadURL withSavePath:savePath Completion:^{
                //解析xml,推出下一个
                CourseParser *parser = [[CourseParser alloc] init];
                parser.resourcePath = saveDocument;
                [parser loadCourses:xmlFileName];
                
                SpeakDetailListViewController *detailList = [[SpeakDetailListViewController alloc] init];
                detailList.course = parser.course;
                detailList.parser = parser;
                [self.navigationController pushViewController:detailList animated:YES];
            }];

        };
        
        NSString *title = [[[self.parser.pkgsArray[indexPath.row] dataPkgCourseInfoArray] objectAtIndex:i] title];
        [actionSheet addButtonWithTitle:title
                                  image:nil
                                   type:AHKActionSheetButtonTypeDefault
                                handler:AHKActionSheetHandler];
    }
    [actionSheet show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"Cell";
    SpeakListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[SpeakListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    DownloadDataPkgInfo *info = self.tableViewData[indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RESOURCE_BASE_URL,info.coverURL]];
    [cell.iconImageView setImageWithURL:imageURL placeholderImage:nil];
    cell.titleLabel.text = info.title;
    return cell;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tableViewData removeAllObjects];
    if ([searchText isEqualToString:@""]) {
        [self.tableViewData addObjectsFromArray:self.parser.pkgsArray];
        [self.speakListTableView reloadData];
        return;
    }
    NSLog(@"%@",searchText);
    for (DownloadDataPkgInfo *info in self.parser.pkgsArray) {
        NSRange range = [info.title rangeOfString:searchText];
        if (range.location != NSNotFound) {
            [self.tableViewData addObject:info];
        }
    }
    [self.speakListTableView reloadData];
}


@end
