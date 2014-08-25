//
//  DailyWordsParser.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-23.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "XMLParser.h"
#import "DailyWordsInfo.h"

@interface DailyWordsParser : XMLParser

@property (nonatomic, strong) NSMutableArray *dailyWordsInfoMArray;

@end
