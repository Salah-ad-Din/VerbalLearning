//
//  LeftSideDrawerViewController.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-7-26.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "LeftSideDrawerViewController.h"
#import "SpeakListViewController.h"
#import "VLSingleton.h"
#import "LoginViewController.h"
#import "StoreDownloadPkg.h"
#import "CurrentInfo.h"

@interface LeftSideDrawerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *navigationTableView;

@end

@implementation LeftSideDrawerViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpeakListViewController *speak = [[SpeakListViewController alloc] init];
    switch (indexPath.row) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseDrawer" object:nil];
            break;
        case 1:
        case 4:
        case 7:
        case 8:
            break;
        case 2:
            speak.xmlURL = nil;
            break;
        case 3:
            speak.xmlURL = nil;
            break;
        case 5:
        {
            speak.lessonType = LESSONTYPE_INTENSIVE;
            LoginViewController *rootVC = [LoginViewController rootViewController];
            NSString *downDir = [[VLSingleton sharedInstance] getCachePath];
            NSString *orgDir = [downDir stringByAppendingString:[NSString stringWithFormat:@"/%ld",(long)rootVC.selectOrgInfo.orgID]];
            NSString *xmlPath = [orgDir stringByAppendingString:[NSString stringWithFormat:@"/intensive.xml"]];
            speak.xmlURL = xmlPath;
            [self.navigationController pushViewController:speak animated:YES];
        }
            break;
        case 6:
        {
            speak.lessonType = LESSONTYPE_EXTENSIVE;
            LoginViewController *rootVC = [LoginViewController rootViewController];
            NSString *downDir = [[VLSingleton sharedInstance] getCachePath];
            NSString *orgDir = [downDir stringByAppendingString:[NSString stringWithFormat:@"/%ld",(long)rootVC.selectOrgInfo.orgID]];
            NSString *xmlPath = [orgDir stringByAppendingString:[NSString stringWithFormat:@"/extensive.xml"]];
            speak.xmlURL = xmlPath;
            [self.navigationController pushViewController:speak animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        default:
            break;
    }
    return 0;
     */
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];

    /*
    if (indexPath.section == 0) {
        cell.textLabel.text = @"首页";
    } else if (indexPath.section == 1 || indexPath.section == 2) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"口语课程";
                break;
            case 1:
                cell.textLabel.text = @"阅读欣赏";
                break;
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        cell.textLabel.text = @"设置";
    } else if (indexPath.section == 4) {
        cell.textLabel.text = @"关于我们";
    }
     */
    switch (row) {
        case 0:
            cell.textLabel.text = @"首页";
            break;
        case 1:
            cell.textLabel.text = @"我的课程";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 2:
            cell.textLabel.text = @"    口语课程";
            break;
        case 3:
            cell.textLabel.text = @"    阅读欣赏";
            break;
        case 4:
            cell.textLabel.text = @"全部课程";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 5:
            cell.textLabel.text = @"    口语课程";
            break;
        case 6:
            cell.textLabel.text = @"    阅读欣赏";
            break;
        case 7:
            cell.textLabel.text = @"设置";
            break;
        case 8:
            cell.textLabel.text = @"关于我们";
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.0];
    
    return cell;
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"我的课程";
    }
    
    if (section == 2) {
        return @"全部课程";
    }
    
    return nil;
}
 */


@end
