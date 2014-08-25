//
//  VLSingleton.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-22.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "VLSingleton.h"

@implementation VLSingleton

+ (VLSingleton *)sharedInstance {
    static dispatch_once_t once;
    static VLSingleton * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[VLSingleton alloc] init];
    });
    return sharedInstance;
}

- (NSString *)getCachePath
{
    NSArray  *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    return [cache objectAtIndex:0];
}

- (NSInteger)getWeekday
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger week = [comps weekday];
    return week;
}

@end
