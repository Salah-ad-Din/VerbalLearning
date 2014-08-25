//
//  HomeDrawerViewController.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-7-26.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "HomeDrawerViewController.h"

@interface HomeDrawerViewController ()

@end

@implementation HomeDrawerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeDrawer) name:@"CloseDrawer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDrawer) name:@"OpenDrawer" object:nil];

    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CloseDrawer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OpenDrawer" object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)closeDrawer
{
    [self closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)openDrawer
{
    [self openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

@end
