//
//  SpeakListViewController.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-3.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeakListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *xmlURL;

@end
