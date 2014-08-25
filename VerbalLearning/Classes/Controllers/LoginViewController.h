//
//  LoginViewController.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14-7-15.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "LoginXMLParser.h"
#import "HomeDrawerViewController.h"
#import "CenterDrawerViewController.h"
#import "LeftSideDrawerViewController.h"
#import "DatabaseOperation.h"
#import "IntensiveInfo.h"
#import "ExtensiveInfo.h"

@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

+ (LoginViewController *) rootViewController;

@property (strong, nonatomic) NSMutableArray *orgInfoMArray;
@property (strong, nonatomic) OrgInfo *selectOrgInfo;
@property (strong, nonatomic) RecommendInfo *selectRecommendInfo;
@property (strong, nonatomic) IntensiveInfo *selectIntensiveInfo;
@property (strong, nonatomic) ExtensiveInfo *selectExtensiveInfo;

@end
