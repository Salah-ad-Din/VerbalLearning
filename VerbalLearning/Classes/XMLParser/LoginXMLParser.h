//
//  LoginXMLParser.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14-7-20.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "XMLParser.h"
#import "ExtensiveInfo.h"
#import "IntensiveInfo.h"
#import "RecommendInfo.h"
#import "OrgInfo.h"

@interface LoginXMLParser : XMLParser

@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, strong) NSString *dailyURL;
@property (nonatomic, strong) NSString *localIP;
@property (nonatomic, strong) ExtensiveInfo *extensiveInfo;
@property (nonatomic, strong) IntensiveInfo *intensiveInfo;
@property (nonatomic, strong) RecommendInfo *recommendInfo;
@property (nonatomic, strong) NSMutableArray *orgInfoMArray;

@end
