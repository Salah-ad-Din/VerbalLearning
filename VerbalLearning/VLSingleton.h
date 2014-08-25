//
//  VLSingleton.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-22.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLSingleton : NSObject

+ (VLSingleton *)sharedInstance;
- (NSString *)getCachePath;
- (NSInteger)getWeekday;

@end
