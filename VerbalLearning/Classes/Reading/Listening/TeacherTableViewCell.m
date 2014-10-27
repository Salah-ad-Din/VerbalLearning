//
//  TeacherTableViewCell.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14/10/26.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "TeacherTableViewCell.h"

@implementation TeacherTableViewCell

-(instancetype)init
{
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"TeacherTableViewCell" owner:nil options:nil];
    self = views[0];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHideTranslateNotification:) name:@"HandleHideTranslate" object:nil];
        return self;
    }
    return nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HandleHideTranslate" object:nil];
}

- (void)handleHideTranslateNotification:(NSNotification *)notifi
{
    self.zhLabel.hidden = !self.zhLabel.hidden;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
