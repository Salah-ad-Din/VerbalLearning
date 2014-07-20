//
//  LoginXMLParser.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-7-20.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "LoginXMLParser.h"

@implementation LoginXMLParser
@synthesize errorMsg = _errorMsg;
@synthesize currentTime = _currentTime;
@synthesize dailyURL = _dailyURL;
@synthesize localIP = _localIP;
@synthesize extensiveInfo = _extensiveInfo;
@synthesize intensiveInfo = _intensiveInfo;
@synthesize recommendInfo = _recommendInfo;
@synthesize orgInfoMArray = _orgInfoMArray;

- (id)initWithXMLData:(NSData *)XMLData
{
    self = [super init];
    if (self) {
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:XMLData];
        
        if ([[xmlDoc objectForKey:LOGIN_SUCCESS] integerValue] == 1) {
            _orgInfoMArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            _currentTime = [xmlDoc objectForKey:LOGIN_CURRENTTIME];
            _dailyURL = [xmlDoc objectForKey:LOGIN_DAILYURL];
            _localIP = [xmlDoc objectForKey:LOGIN_IP];
            NSDictionary *dataDoc = [xmlDoc objectForKey:LOGIN_DATA];
            
            NSString *resourceHost = [dataDoc objectForKey:LOGIN_RSURL];
            //extensive
            NSDictionary *extensiveDoc = [dataDoc objectForKey:LOGIN_EXTENSIVE];
            _extensiveInfo = [[ExtensiveInfo alloc] init];
            _extensiveInfo.extensiveXMLURL = [resourceHost stringByAppendingString:[extensiveDoc objectForKey:LOGIN_TEXT]];
            _extensiveInfo.expireMD5 = [extensiveDoc objectForKey:LOGIN_MD5];
            
            //intensive
            NSDictionary *intensiveDoc = [dataDoc objectForKey:LOGIN_INTENSIVE];
            _intensiveInfo = [[IntensiveInfo alloc] init];
            _intensiveInfo.intensiveXMLURL = [resourceHost stringByAppendingString:[intensiveDoc objectForKey:LOGIN_TEXT]];
            _intensiveInfo.expireMD5 = [intensiveDoc objectForKey:LOGIN_MD5];
            
            //recommend
            NSDictionary *recommendDoc = [dataDoc objectForKey:LOGIN_RECOMMEND];
            _recommendInfo = [[RecommendInfo alloc] init];
            _recommendInfo.intensiveXMLURL = [resourceHost stringByAppendingString:[recommendDoc objectForKey:LOGIN_TEXT]];
            _recommendInfo.expireMD5 = [recommendDoc objectForKey:LOGIN_MD5];
            
            //org info
            id orgStruct = [dataDoc objectForKey:LOGIN_ORGNAME];
            if ([orgStruct isKindOfClass:[NSDictionary class]]) {
                OrgInfo *info = [[OrgInfo alloc] init];
                info.orgName = [orgStruct objectForKey:LOGIN_TEXT];
                info.orgID = [orgStruct objectForKey:LOGIN_ORGID];
                [_orgInfoMArray addObject:info];
            } else if ([orgStruct isKindOfClass:[NSArray class]]) {
                for (NSDictionary *orgDoc in orgStruct) {
                    OrgInfo *info = [[OrgInfo alloc] init];
                    info.orgName = [orgDoc objectForKey:LOGIN_TEXT];
                    info.orgID = [orgDoc objectForKey:LOGIN_ORGID];
                    [_orgInfoMArray addObject:info];
                }
            }
        } else {
            _errorMsg = [xmlDoc objectForKey:LOGIN_FAILDESC];
        }
    }
    return self;
}

@end


/*
 
 Printing description of xmlDoc:
 {
 "__name" = root;
 currenttime = 1405846452;
 dailyurl = "http://m.isayb.com/daily/1405872000.xml";
 data =     {
 extensive =         {
 "__text" = "extensive.xml";
 "_md5" = d3af4242c9c89e5eb894d01ccd2408fb;
 };
 intensive =         {
 "__text" = "intensive.xml";
 "_md5" = 2452d968a3a941761f3eb9e6e1da3b60;
 };
 name =         {
 "__text" = "\U5584\U7f18\U5f69\U548c\U574a--\U59cb\U4e8e1715\U5de5\U4f5c\U5ba4";
 "_id" = 1142;
 };
 pkg = "index_android.xml";
 recommend =         {
 "__text" = "recommend.xml";
 "_md5" = da9b86e7531e90d7a2de933a9d9885c4;
 };
 rsurl = "http://m.isayb.com/rs/";
 };
 ip = "123.126.074.051";
 success = 1;
 }
 
 */
