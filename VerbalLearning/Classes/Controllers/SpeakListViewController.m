//
//  SpeakListViewController.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-3.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "SpeakListViewController.h"

@interface SpeakListViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation SpeakListViewController

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

@end
