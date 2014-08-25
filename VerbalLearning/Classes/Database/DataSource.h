//
//  DataSource.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-6.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject
+ (DataSource *)sharedDataSource;
- (BOOL)copyDatabaseToDocument;
- (NSString *)getDatabasePath;
@end
