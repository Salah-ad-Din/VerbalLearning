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
#import "LoginViewController.h"
#import "ListeningViewController.h"
@interface SpeakDetailListViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;

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
    _orgNameLabel.text = [LoginViewController rootViewController].selectOrgInfo.orgName;
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nPostion = indexPath.row;
    ListeningViewController *detailViewController = [[ListeningViewController alloc] initWithNibName:@"ListeningViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.

    if (nPostion < ([self.course.lessons count])) {
        detailViewController.nPositionInCourse = nPostion;
        detailViewController.courseParser = self.parser;
        detailViewController.delegate = (id)self;
  		//[[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_ADDNEWNAVI object: detailViewController];
        //[detailViewController release];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }

}

@end
