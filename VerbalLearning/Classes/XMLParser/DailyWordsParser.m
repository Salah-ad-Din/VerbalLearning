//
//  DailyWordsParser.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-23.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "DailyWordsParser.h"

@implementation DailyWordsParser

@synthesize dailyWordsInfoMArray = _dailyWordsInfoMArray;

- (id)initWithXMLData:(NSData *)XMLData
{
    self = [super init];
    if (self) {
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:XMLData];
        NSArray *arr = [xmlDoc objectForKey:@"day"];
        _dailyWordsInfoMArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in arr) {
            DailyWordsInfo *info = [[DailyWordsInfo alloc] init];
            info.chinese = [dic objectForKey:@"chn"];
            info.english = [dic objectForKey:@"enu"];
            [_dailyWordsInfoMArray addObject:info];
        }
    }
    return self;
}

@end
