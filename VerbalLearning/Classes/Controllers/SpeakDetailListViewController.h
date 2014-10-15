//
//  SpeakDetailListViewController.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-30.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "CourseParser.h"
@interface SpeakDetailListViewController : UIViewController

@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) CourseParser *parser;
@property (nonatomic, retain) NSString* pkgTitle;

@end
