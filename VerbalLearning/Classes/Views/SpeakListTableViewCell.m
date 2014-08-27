//
//  SpeakListTableViewCell.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-27.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "SpeakListTableViewCell.h"

@implementation SpeakListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 56, 70)];
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200, 70)];
        [self addSubview:self.titleLabel];
        
        UIFont *defaultFont = [UIFont boldSystemFontOfSize:15.0f];
        [self.titleLabel setFont:defaultFont];
    }
    return self;
}

@end
