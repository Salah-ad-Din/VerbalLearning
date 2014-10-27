//
//  TeacherTableViewCell.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14/10/26.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *teacherImage;
@property (weak, nonatomic) IBOutlet UILabel *engLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhLabel;

@end
