//
//  SpeakListViewController.m
//  VerbalLearning
//
//  Created by Raymond Lee on 14-8-3.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import "SpeakListViewController.h"
#import "StoreVoiceDataListParser.h"
#import "UIImageView+AFNetworking.h"
#import "VoicePkgInfoObject.h"
#import "SpeakListTableViewCell.h"

@interface SpeakListViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) StoreVoiceDataListParser *parser;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *speakListTableView;

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

-(void)setXmlURL:(NSString *)xmlURL
{
    _xmlURL = xmlURL;
    StoreVoiceDataListParser *parser = [[StoreVoiceDataListParser alloc] init];
    NSData* filedata = [NSData dataWithContentsOfFile:xmlURL];
    [parser loadWithPkgData:filedata];
    self.parser = parser;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.parser.pkgsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"Cell";
    SpeakListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[SpeakListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    DownloadDataPkgInfo *info = self.parser.pkgsArray[indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",RESOURCE_BASE_URL,info.coverURL]];
    [cell.iconImageView setImageWithURL:imageURL placeholderImage:nil];
    cell.titleLabel.text = info.title;
    return cell;
}


@end
