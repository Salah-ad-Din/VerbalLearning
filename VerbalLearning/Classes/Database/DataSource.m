//
//  DataSource.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-6.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
static DataSource *sharedDataSource;
+ (DataSource *) sharedDataSource {
    if (sharedDataSource == nil) {
        sharedDataSource = [[DataSource alloc] init];
    }
    return sharedDataSource;
}

- (BOOL)copyDatabaseToDocument {
	NSError *error = nil;
	NSString *sqlitePath = [self getDatabasePath];
	if (![[NSFileManager defaultManager] fileExistsAtPath:sqlitePath isDirectory:nil]) {
        NSString *homePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/Database"];
		NSString *copyFromDatabasePath = [homePath stringByAppendingPathComponent:DATABASE_NAME];
		[[NSFileManager defaultManager] copyItemAtPath:copyFromDatabasePath toPath:sqlitePath error:&error];
        if (error) {
            NSLog(@"Error:%@", [error description]);
        }
		return YES;
	}
	return NO;
}

- (NSString *)getDatabasePath {
	NSString *sqlitePath = [self getUserDataPath];
	sqlitePath = [sqlitePath stringByAppendingPathComponent:DIR_DATABASE];
	if (![[NSFileManager defaultManager] fileExistsAtPath:sqlitePath isDirectory:nil])
		[[NSFileManager defaultManager] createDirectoryAtPath:sqlitePath withIntermediateDirectories:YES attributes:nil error:nil];
    
	sqlitePath = [sqlitePath stringByAppendingPathComponent:DATABASE_NAME];
	return sqlitePath;
}


- (NSString *)getUserDataPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentDIrectory = [paths objectAtIndex:0];
    NSString *path = [documentDIrectory stringByAppendingString:PATH_USERDATA];
    if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES
                                attributes:nil error:nil];
    }
    return path;
}

@end
