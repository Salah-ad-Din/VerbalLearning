//
//  DatabaseOperation.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-10.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DataSource.h"
#import "OrgInfo.h"

@interface DatabaseOperation : NSObject {
	sqlite3     *_database;
    NSLock      *databaseLock;
}

/**
 *  初始化数据库
 *
 *  @return 数据库对象
 */
+ (DatabaseOperation *)database;

/**
 *  插入机构信息
 *
 *  @param orgInfo 机构信息对象
 *
 *  @return 插入是否成功
 */
- (BOOL)insertOrgInfo:(OrgInfo *)orgInfo;

/**
 *  插入机构对应的XML版本号
 *
 *  @param recommendMD5 XML版本号
 *  @param intensiveMD5 XML版本号
 *  @param extensiveMD5 XML版本号
 *  @param orgID        机构ID
 *
 *  @return 插入是否成功
 */
- (BOOL)insertRecommendMD5:(NSString *)recommendMD5
              intensiveMD5:(NSString *)intensiveMD5
              extensiveMD5:(NSString *)extensiveMD5
                 withOrgID:(NSInteger)orgID;

/**
 *  查询机构信息
 *
 *  @param orgID 机构ID
 *
 *  @return 返回机构信息
 */
- (OrgInfo *)selectOrgInfoWithOrgID:(NSInteger)orgID;

/**
 *  查询对应机构的recommendXML的版本号
 *
 *  @param orgID 机构ID
 *
 *  @return 当前的版本号
 */
- (NSString *)selectRecommendMD5WithOrgID:(NSInteger)orgID;

/**
 *  查询对应机构的recommendXML的版本号
 *
 *  @param orgID 机构ID
 *
 *  @return 当前的版本号
 */
- (NSString *)selectIntensiveMD5WithOrgID:(NSInteger)orgID;

/**
 *  查询对应机构的extensiveXML的版本号
 *
 *  @param orgID 机构ID
 *
 *  @return 当前的版本号
 */
- (NSString *)selectExtensiveMD5WithOrgID:(NSInteger)orgID;

/**
 *  更新对应机构的recommendXML的版本号
 *
 *  @param md5   XML版本号
 *  @param orgID 机构ID
 *
 *  @return 更新是否成功
 */
- (BOOL)updateRecommendMD5:(NSString *)md5 withOrgID:(NSInteger)orgID;

/**
 *  更新对应机构的intensiveXML的版本号
 *
 *  @param md5   XML版本号
 *  @param orgID 机构ID
 *
 *  @return 更新是否成功
 */
- (BOOL)updateIntensiveMD5:(NSString *)md5 withOrgID:(NSInteger)orgID;

/**
 *  更新对应机构的extensiveXML的版本号
 *
 *  @param md5   XML版本号
 *  @param orgID 机构ID
 *
 *  @return 更新是否成功
 */
- (BOOL)updateExtensiveMD5:(NSString *)md5 withOrgID:(NSInteger)orgID;

@end
