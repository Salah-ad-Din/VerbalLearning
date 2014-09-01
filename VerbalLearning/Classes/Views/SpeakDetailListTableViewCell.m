//
//  SpeakDetailListTableViewCell.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-9-1.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "SpeakDetailListTableViewCell.h"

@implementation SpeakDetailListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 64, 64)];
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, 220, 70)];
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
        
        UIFont *defaultFont = [UIFont boldSystemFontOfSize:15.0f];
        [self.titleLabel setFont:defaultFont];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
