//
//  DatabaseOperation.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-10.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "DatabaseOperation.h"


@implementation DatabaseOperation

static DatabaseOperation *_shareDatabase;
+ (DatabaseOperation *)database {
	if (_shareDatabase == nil) {
		_shareDatabase = [[DatabaseOperation alloc] init];
	}
	return _shareDatabase;
}

- (id)init {
	if ((self = [super init])) {
        /*
		NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES);
		NSString *docsDir = [paths objectAtIndex:0];
        NSArray  *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                              NSUserDomainMask, YES);
        NSString *downDir = [cache objectAtIndex:0];
		NSArray  *libary = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask, YES);
		NSString *libaryDir = [libary objectAtIndex:0];
		if (strDocumentsDir == nil) {
			strDocumentsDir = [[NSString alloc] initWithString:docsDir];
		}
        if (strDownloadBookDir == nil) {
            strDownloadBookDir = [[NSString alloc] initWithString:downDir];
        }
		if (strLibaryDir == nil) {
			strLibaryDir = [[NSString alloc] initWithString:libaryDir];
		}
         */
        
		NSString *sqlitePath = [[DataSource sharedDataSource] getDatabasePath];
        databaseLock = [[NSLock alloc] init];
		
		if (sqlite3_open([sqlitePath UTF8String], (sqlite3 **)(&_database)) != SQLITE_OK) {
			NSLog(@"Failed to open database");
		} else {
            NSLog(@"Open database");
        }
        
	}
	return self;
}

//insert
- (BOOL)insertOrgInfo:(OrgInfo *)orgInfo
{
    [databaseLock lock];

    sqlite3_stmt *statement;
	NSString *sql = @"INSERT INTO OrgInfo (OrgID, OrgName) VALUES(?,?)";
	int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
	if (success == SQLITE_OK) {
        NSInteger i = 1;
        //OrgID
		sqlite3_bind_int(statement, i, orgInfo.orgID);
		i++;
        sqlite3_bind_text(statement, i, [orgInfo.orgName UTF8String], -1, SQLITE_TRANSIENT);
        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		[databaseLock unlock];
        
        if (success == SQLITE_ERROR) {
			NSLog(@"Error: failed to insert into the database with message");
			return NO;
		}
    } else {
        [databaseLock unlock];
		NSLog(@"Error: failed to insert:OrgInfo");
		return NO;
    }
    return YES;
}

- (BOOL)insertRecommendMD5:(NSString *)recommendMD5
              intensiveMD5:(NSString *)intensiveMD5
              extensiveMD5:(NSString *)extensiveMD5
                 withOrgID:(NSInteger)orgID
{
    [databaseLock lock];
    
    sqlite3_stmt *statement;
	NSString *sql = @"INSERT INTO XMLInfo (OrgID, RecommendMD5, IntensiveMD5, ExtensiveMD5) VALUES(?,?,?,?)";
	int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
	if (success == SQLITE_OK) {
        NSInteger i = 1;
        //OrgID
		sqlite3_bind_int(statement, i, orgID);
		i++;
        sqlite3_bind_text(statement, i, [recommendMD5 UTF8String], -1, SQLITE_TRANSIENT);
		i++;
        sqlite3_bind_text(statement, i, [intensiveMD5 UTF8String], -1, SQLITE_TRANSIENT);
		i++;
        sqlite3_bind_text(statement, i, [extensiveMD5 UTF8String], -1, SQLITE_TRANSIENT);
		i++;
        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		[databaseLock unlock];
        
        if (success == SQLITE_ERROR) {
			NSLog(@"Error: failed to insert into the database with message");
			return NO;
		}
    } else {
        [databaseLock unlock];
		NSLog(@"Error: failed to insert:XMLInfo");
		return NO;
    }
    return YES;
}

//select
- (OrgInfo *)selectOrgInfoWithOrgID:(NSInteger)orgID
{
    [databaseLock lock];
	sqlite3_stmt *statement;
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT OrgID, OrgName FROM OrgInfo WHERE OrgID = %d", orgID];
	int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
    if (success == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            OrgInfo *info = [[OrgInfo alloc] init];
            NSInteger nIndex = 0;
            info.orgID = sqlite3_column_int(statement, nIndex);
            nIndex++;
            char *orgName = (char *)sqlite3_column_text(statement, nIndex);
            info.orgName = [[NSString alloc] initWithUTF8String:orgName];
            sqlite3_finalize(statement);
            [databaseLock unlock];
            return info;
        }
    }
    sqlite3_finalize(statement);
	[databaseLock unlock];
    return nil;
}

- (NSString *)selectRecommendMD5WithOrgID:(NSInteger)orgID
{
    [databaseLock lock];
	sqlite3_stmt *statement;
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT RecommendMD5 FROM XMLInfo WHERE OrgID = %d", orgID];
	int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
    if (success == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            char *recommendMD5Char = (char *) sqlite3_column_text(statement, 0);
            if (recommendMD5Char == NULL) {
                break;
            }
            NSString *recommendMD5 = [[NSString alloc] initWithUTF8String:recommendMD5Char];
            sqlite3_finalize(statement);
            [databaseLock unlock];
            return recommendMD5;
        }
    }
    sqlite3_finalize(statement);
	[databaseLock unlock];
    return nil;
}

- (NSString *)selectIntensiveMD5WithOrgID:(NSInteger)orgID
{
    [databaseLock lock];
	sqlite3_stmt *statement;
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT IntensiveMD5 FROM XMLInfo WHERE OrgID = %d", orgID];
	int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
    if (success == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            char *intensiveMD5Char = (char *) sqlite3_column_text(statement, 0);
            if (intensiveMD5Char == NULL) {
                break;
            }
            NSString *intensiveMD5 = [[NSString alloc] initWithUTF8String:intensiveMD5Char];
            sqlite3_finalize(statement);
            [databaseLock unlock];
            return intensiveMD5;
        }
    }
    sqlite3_finalize(statement);
	[databaseLock unlock];
    return nil;
}

- (NSString *)selectExtensiveMD5WithOrgID:(NSInteger)orgID
{
    [databaseLock lock];
	sqlite3_stmt *statement;
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT ExtensiveMD5 FROM XMLInfo WHERE OrgID = %d", orgID];
	int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
    if (success == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            char *extensiveMD5Char = (char *) sqlite3_column_text(statement, 0);
            if (extensiveMD5Char == NULL) {
                break;
            }
            NSString *extensiveMD5 = [[NSString alloc] initWithUTF8String:extensiveMD5Char];
            sqlite3_finalize(statement);
            [databaseLock unlock];
            return extensiveMD5;
        }
    }
    sqlite3_finalize(statement);
	[databaseLock unlock];
    return nil;
}

//update
- (BOOL)updateRecommendMD5:(NSString *)md5 withOrgID:(NSInteger)orgID
{
    [databaseLock lock];
    sqlite3_stmt *statement;
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"UPDATE XMLInfo SET RecommendMD5 = ? WHERE OrgID = %d", orgID];
    int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
    if (success == SQLITE_OK) {
        NSInteger i = 1;
        sqlite3_bind_text(statement, i, [md5 UTF8String], -1, SQLITE_TRANSIENT);
		i++;
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        [databaseLock unlock];
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to %@", sql);
            return NO;
        }
    } else {
        [databaseLock unlock];
        NSLog(@"Error: failed to %@", sql);
        return NO;
    }
    return YES;
}

- (BOOL)updateIntensiveMD5:(NSString *)md5 withOrgID:(NSInteger)orgID
{
    [databaseLock lock];
    sqlite3_stmt *statement;
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"UPDATE XMLInfo SET IntensiveMD5 = ? WHERE OrgID = %d", orgID];
    int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
    if (success == SQLITE_OK) {
        NSInteger i = 1;
        sqlite3_bind_text(statement, i, [md5 UTF8String], -1, SQLITE_TRANSIENT);
		i++;
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        [databaseLock unlock];
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to %@", sql);
            return NO;
        }
    } else {
        [databaseLock unlock];
        NSLog(@"Error: failed to %@", sql);
        return NO;
    }
    return YES;
}

- (BOOL)updateExtensiveMD5:(NSString *)md5 withOrgID:(NSInteger)orgID
{
    [databaseLock lock];
    sqlite3_stmt *statement;
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"UPDATE XMLInfo SET ExtensiveMD5 = ? WHERE OrgID = %d", orgID];
    int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
    if (success == SQLITE_OK) {
        NSInteger i = 1;
        sqlite3_bind_text(statement, i, [md5 UTF8String], -1, SQLITE_TRANSIENT);
		i++;
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        [databaseLock unlock];
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to %@", sql);
            return NO;
        }
    } else {
        [databaseLock unlock];
        NSLog(@"Error: failed to %@", sql);
        return NO;
    }
    return YES;
}


@end
