//
//  CenterDrawerViewController.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-7-26.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "CenterDrawerViewController.h"
#import "StoreVoiceDataListParser.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "VoicePkgInfoObject.h"
#import "DailyWordsParser.h"
#import "DailyWordsInfo.h"
#import "VLSingleton.h"
#import "AHKActionSheet.h"
#import "SpeakListViewController.h"
#import "CourseParser.h"
#import "SpeakDetailListViewController.h"
#import "StoreDownloadPkg.h"
#import "CurrentInfo.h"

@interface CenterDrawerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *navigationButton;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;
@property (strong, nonatomic) StoreVoiceDataListParser *parser;
@property (strong, nonatomic) DailyWordsParser *dailyParser;
@property (weak, nonatomic) IBOutlet UIImageView *intensiveViewLeft;
@property (weak, nonatomic) IBOutlet UILabel *intensiveLabelLeft;
@property (weak, nonatomic) IBOutlet UIImageView *intensiveViewCenter;
@property (weak, nonatomic) IBOutlet UILabel *intensiveLabelCenter;
@property (weak, nonatomic) IBOutlet UIImageView *intensiveViewRight;
@property (weak, nonatomic) IBOutlet UILabel *intensiveLabelRight;
@property (weak, nonatomic) IBOutlet UIImageView *extensiveView;
@property (weak, nonatomic) IBOutlet UILabel *extensiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *extensiveDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishDailyLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseDailyLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *intensiveMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *extensiveMoreButton;

@end

@implementation CenterDrawerViewController

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
    //parse xml:recommend
    LoginViewController *rootVC = [LoginViewController rootViewController];
    NSString *downDir = [[VLSingleton sharedInstance] getCachePath];
    NSString *orgDir = [downDir stringByAppendingString:[NSString stringWithFormat:@"/%ld",(long)rootVC.selectOrgInfo.orgID]];
    NSString *xmlSavePath = [orgDir stringByAppendingString:[NSString stringWithFormat:@"/recommend.xml"]];
    
    StoreVoiceDataListParser *parser = [[StoreVoiceDataListParser alloc] init];
    NSData* filedata = [NSData dataWithContentsOfFile:xmlSavePath];
    [parser loadWithData:filedata];
    self.parser = parser;
    
    NSString *dailyXMLPath = [downDir stringByAppendingString:@"/daily.xml"];
    DailyWordsParser *dailyParser = [[DailyWordsParser alloc] initWithXMLData:[NSData dataWithContentsOfFile:dailyXMLPath]];
    self.dailyParser = dailyParser;
    
    if (self.parser) {
        [self refreshUI];
    }
    
    _intensiveViewLeft.layer.borderWidth = 1.0f;
    _intensiveViewLeft.layer.borderColor = [UIColor grayColor].CGColor;
    _intensiveViewLeft.tag = 1001;
    _intensiveViewCenter.layer.borderWidth = 1.0f;
    _intensiveViewCenter.layer.borderColor = [UIColor grayColor].CGColor;
    _intensiveViewCenter.tag = 1002;
    _intensiveViewRight.layer.borderWidth = 1.0f;
    _intensiveViewRight.layer.borderColor = [UIColor grayColor].CGColor;
    _intensiveViewRight.tag = 1003;
    _extensiveView.layer.borderWidth = 1.0f;
    _extensiveView.layer.borderColor = [UIColor grayColor].CGColor;
    _extensiveView.tag = 1004;
    CurrentInfo* lib = [CurrentInfo sharedCurrentInfo];
    lib.currentLibID = [LoginViewController rootViewController].selectOrgInfo.orgID;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigationButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenDrawer" object:nil];
}

- (void)refreshUI {
    //星期label
    NSString *weekDayString = nil;
    NSInteger week = [[VLSingleton sharedInstance] getWeekday];
    switch (week) {
        case 1:
            weekDayString = @"星期日";
            break;
        case 2:
            weekDayString = @"星期一";
            break;
        case 3:
            weekDayString = @"星期二";
            break;
        case 4:
            weekDayString = @"星期三";
            break;
        case 5:
            weekDayString = @"星期四";
            break;
        case 6:
            weekDayString = @"星期五";
            break;
        case 7:
            weekDayString = @"星期六";
            break;
        default:
            break;
    }
    _weekDayLabel.text = weekDayString;
    
    //每日一句
    switch (week) {
        //五六日相同
        case 6:
        case 7:
        case 1:
        {
            DailyWordsInfo *info = self.dailyParser.dailyWordsInfoMArray[0];
            _englishDailyLabel.text = info.english;
            _chineseDailyLabel.text = info.chinese;
        }
            break;
        default:
        {
            DailyWordsInfo *info = self.dailyParser.dailyWordsInfoMArray[week - 1];
            _englishDailyLabel.text = info.english;
            _chineseDailyLabel.text = info.chinese;
        }
            break;
    }
    
    DownloadDataPkgInfo *info = self.parser.intensiveMArray[0];
    
    //口语专题推荐左
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RESOURCE_BASE_URL,info.coverURL]];
    [self.intensiveViewLeft setImageWithURL:imageURL];
    self.intensiveLabelLeft.text = info.title;
    
    //口语专题推荐中
    info = self.parser.intensiveMArray[1];
    imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RESOURCE_BASE_URL,info.coverURL]];
    [self.intensiveViewCenter setImageWithURL:imageURL];
    self.intensiveLabelCenter.text = info.title;

    //口语专题推荐右
    info = self.parser.intensiveMArray[2];
    imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RESOURCE_BASE_URL,info.coverURL]];
    [self.intensiveViewRight setImageWithURL:imageURL];
    self.intensiveLabelRight.text = info.title;
    
    //阅读欣赏专题
    info = self.parser.extensiveMArray[0];
    imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RESOURCE_BASE_URL,info.coverURL]];
    [self.extensiveView setImageWithURL:imageURL];
    self.extensiveLabel.text = info.title;
    //详情
    self.extensiveDetailLabel.text = info.intro;
    
    //标题
    self.orgNameLabel.text = [LoginViewController rootViewController].selectOrgInfo.orgName;

}

- (IBAction)didPressView:(UITapGestureRecognizer *)gesture
{

    LESSONTYPE viewType;
    NSInteger order = 0;
    
    switch (gesture.view.tag) {
        case 1001:
            viewType = LESSONTYPE_INTENSIVE;
            order = 0;
            break;
        case 1002:
            viewType = LESSONTYPE_INTENSIVE;
            order = 1;
            break;
        case 1003:
            viewType = LESSONTYPE_INTENSIVE;
            order = 2;
            break;
        case 1004:
            viewType = LESSONTYPE_EXTENSIVE;
            order = 0;
            break;
        default:
            break;
    }
    
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
    if (viewType == LESSONTYPE_INTENSIVE) {
        label1.text = [self.parser.intensiveMArray[order] title];
    } else {
        label1.text = [self.parser.extensiveMArray[order] title];
    }
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont fontWithName:@"Avenir" size:17.0f];
    label1.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label1];

    actionSheet.headerView = headerView;
    

    NSInteger count = 0;
    if (viewType == LESSONTYPE_INTENSIVE) {
        count = [[self.parser.intensiveMArray[order] dataPkgCourseInfoArray] count];
        StoreDownloadPkg* downloadPkg = [[StoreDownloadPkg alloc] init];
        downloadPkg.info = self.parser.intensiveMArray[order];
        downloadPkg.info.libID = [LoginViewController rootViewController].selectOrgInfo.orgID;
        [downloadPkg doDownload];
        CurrentInfo* lib = [CurrentInfo sharedCurrentInfo];
        NSRange r = [[downloadPkg getpkgPath] rangeOfString:STRING_VOICE_PKG_DIR];
        if (r.location != NSNotFound) {
            NSString* path = [[downloadPkg getpkgPath] substringFromIndex:(r.location + r.length + 1)];
            lib.currentPkgDataPath = path;
            lib.currentLibID = downloadPkg.info.libID;
            lib.lessonType = LESSONTYPE_INTENSIVE;
         }

    } else {
        count = [[self.parser.extensiveMArray[order] dataPkgCourseInfoArray] count];
        StoreDownloadPkg* downloadPkg = [[StoreDownloadPkg alloc] init];
        downloadPkg.info = self.parser.extensiveMArray[order];
        downloadPkg.info.libID = [LoginViewController rootViewController].selectOrgInfo.orgID;
        [downloadPkg doDownload];
        CurrentInfo* lib = [CurrentInfo sharedCurrentInfo];
        NSRange r = [[downloadPkg getpkgPath] rangeOfString:STRING_VOICE_PKG_DIR];
        if (r.location != NSNotFound) {
            NSString* path = [[downloadPkg getpkgPath] substringFromIndex:(r.location + r.length + 1)];
            lib.currentPkgDataPath = path;
            lib.currentLibID = downloadPkg.info.libID;
            lib.lessonType = LESSONTYPE_EXTENSIVE;
        }
    }
    for (int i = 0; i < count; i++) {
        NSString *title = nil;
        NSString *xmlFileName = nil;

        if (viewType == LESSONTYPE_INTENSIVE) {
            title = [[[self.parser.intensiveMArray[order] dataPkgCourseInfoArray] objectAtIndex:i] title];
            xmlFileName = [[[self.parser.intensiveMArray[order] dataPkgCourseInfoArray] objectAtIndex:i] file];
        } else {
            title = [[[self.parser.extensiveMArray[order] dataPkgCourseInfoArray] objectAtIndex:i] title];
            xmlFileName = [[[self.parser.extensiveMArray[order] dataPkgCourseInfoArray] objectAtIndex:i] file];
        }
        
        //选择block
        void(^AHKActionSheetHandler)(AHKActionSheet *actionSheet) = ^(AHKActionSheet *actionSheet){
            NSString *dowloadURL = [RESOURCE_BASE_URL stringByAppendingString:xmlFileName];
            
            NSString *saveDocument = [[VLSingleton sharedInstance] getCachePath];
            saveDocument = [saveDocument stringByAppendingString:[NSString stringWithFormat:@"/%ld/",(long)[LoginViewController rootViewController].selectOrgInfo.orgID]];
            NSString *savePath = [saveDocument stringByAppendingString:xmlFileName];
            
            [self downloadResourceXML:dowloadURL withSavePath:savePath Completion:^{
                //解析xml,推出下一个
                CourseParser *parser = [[CourseParser alloc] init];
                parser.resourcePath = saveDocument;
                parser.resourceSaveDataPath = [[[VLSingleton sharedInstance] getCachePath] stringByAppendingFormat:@"/%@/",STRING_VOICE_PKG_DIR];
                [parser loadCourses:xmlFileName];
                
                SpeakDetailListViewController *detailList = [[SpeakDetailListViewController alloc] init];
                detailList.course = parser.course;
                detailList.parser = parser;
                detailList.pkgTitle = title;
                [self.navigationController pushViewController:detailList animated:YES];
            }];
            
        };
        
        [actionSheet addButtonWithTitle:title
                                  image:nil
                                   type:AHKActionSheetButtonTypeDefault
                                handler:AHKActionSheetHandler];
    }
    [actionSheet show];
}


- (IBAction)pressMoreButton:(id)sender
{
    SpeakListViewController *speak = [[SpeakListViewController alloc] init];
    if (sender == self.intensiveMoreButton) {
        LoginViewController *rootVC = [LoginViewController rootViewController];
        NSString *downDir = [[VLSingleton sharedInstance] getCachePath];
        NSString *orgDir = [downDir stringByAppendingString:[NSString stringWithFormat:@"/%ld",(long)rootVC.selectOrgInfo.orgID]];
        NSString *xmlPath = [orgDir stringByAppendingString:[NSString stringWithFormat:@"/intensive.xml"]];
        speak.xmlURL = xmlPath;
        [self.navigationController pushViewController:speak animated:YES];
    } else {
        LoginViewController *rootVC = [LoginViewController rootViewController];
        NSString *downDir = [[VLSingleton sharedInstance] getCachePath];
        NSString *orgDir = [downDir stringByAppendingString:[NSString stringWithFormat:@"/%ld",(long)rootVC.selectOrgInfo.orgID]];
        NSString *xmlPath = [orgDir stringByAppendingString:[NSString stringWithFormat:@"/extensive.xml"]];
        speak.xmlURL = xmlPath;
        [self.navigationController pushViewController:speak animated:YES];
    }
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

@end
