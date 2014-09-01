//
//  SpeakDetailListViewController.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-30.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "SpeakDetailListViewController.h"
#import "SpeakDetailListTableViewCell.h"
#import "Lesson.h"

@interface SpeakDetailListViewController ()

@end

@implementation SpeakDetailListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToPrevios:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.course.lessons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"Cell";
    SpeakDetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[SpeakDetailListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.titleLabel.text = [(Lesson *)self.course.lessons[indexPath.row] title];
    cell.iconImageView.image = [UIImage imageNamed:@"Headphones"];
    return cell;
}

@end
