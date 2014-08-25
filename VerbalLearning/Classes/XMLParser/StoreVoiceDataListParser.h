//
//  StoreVoiceDataListParser.h
//  Sanger
//
//  Created by JiaLi on 12-9-19.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"


@interface StoreVoiceDataListParser : NSObject

@property (nonatomic, retain, readwrite) NSMutableArray* serverlistArray;
//@property (nonatomic, retain, readwrite) NSMutableArray* pkgsArray;
@property (nonatomic, strong) NSMutableArray *intensiveMArray;
@property (nonatomic, strong) NSMutableArray *extensiveMArray;
@property (nonatomic, assign) NSInteger libID;
- (void)loadWithPath:(NSString*)path;
- (void)loadWithData:(NSData*)data;

@end
