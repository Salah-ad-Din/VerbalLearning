//
//  ListeningArticleViewController.h
//  VerbalLearning
//
//  Created by Raymond Lee on 14/10/24.
//  Copyright (c) 2014年 rayxar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "ListeningToolbar.h"
#import "SettingData.h"
#import "CourseParser.h"
#import "CollapseClick.h"
#import "ButtonPlayObject.h"
#import "DownloadLesson.h"

@class RecordingObject;
#define VOLUMNVIEW_TAG  50001
#define READYRECORDINGVIEW_TAG  50102

@protocol ListeningArticleViewControllerDelegate <NSObject>

- (NSString*)getPkgTitle;
- (NSString*)getCourseTitle;

@end

@interface ListeningArticleViewController : UIViewController<AVAudioPlayerDelegate>
{
    NSMutableArray*                 _sentencesArray;
    NSMutableArray*                 _teachersArray;
    UITableView*                    _sentencesTableView;
    //ListeningToolbar*               _listeningToolbar;
    UIBarButtonItem*                _recordingItem;
    UISlider*                       progressBar;
    //UILabel* timepreces;
    //UILabel* timelast;
    UILabel*                        senCount;
    NSTimer*                        updateTimer;
    NSTimer*                        playTimer;
    NSTimer*                        pauseTimer;
    int                             nLesson;
    BOOL                            bRecording;
    NSString*                       wavefile;         // 音频文件
    NSString*                       _isbfile;
    NSString*                       resourcePath;
    AVAudioPlayer *                 player;
    RecordingObject*                _recording;
    
    // 循环控制
    NSTimeInterval                  loopstarttime;   // 循环开始时间
    NSTimeInterval                  loopendtime;     // 循环结束时间
    
    NSTimeInterval                  timeStart;       // 起始时间
    
    NSInteger                       nPosition;       // 滚动位置
    CGFloat                         fVolumn;
    PLAY_STATUS                     ePlayStatus;
    SettingData*                    settingData;
    NSInteger                       nCurrentReadingCount;
    NSInteger                       nLastScrollPos;
    BOOL                            bInit;
    BOOL                            bParseWAV;
    
    NSInteger                       endSection;
    NSInteger                       didSection;
    BOOL                            ifOpen;
    NSInteger                       clickindex;
    NSInteger                       lastClickIndex;
    ButtonPlayObject*               _buttonPlay;
    BOOL                            _bReadFlowMe;
    
    UIButton*                       readeButton;
    UIButton*                       practiceButton;
    DownloadLesson*                 _downloadLessonObj;
    NSMutableArray*                 _scroeArray;
    NSInteger                       _lastPlayIndexforPause;
}

@property (nonatomic, retain) NSMutableArray* sentencesArray;
@property (nonatomic, retain) NSMutableArray* teachersArray;
//@property (nonatomic, retain) IBOutlet ListeningToolbar* listeningToolbar;
@property (nonatomic, retain) IBOutlet UITableView* sentencesTableView;
@property (nonatomic, retain) IBOutlet UISlider* progressBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* recordingItem;
//@property (nonatomic, retain) IBOutlet UILabel* timepreces;
//@property (nonatomic, retain) IBOutlet UILabel* timelast;
@property (nonatomic, retain) IBOutlet UILabel* senCount;
@property (nonatomic, retain) NSTimer* updataeTimer;
@property (nonatomic, retain) NSString* wavefile;
@property (nonatomic, retain) NSString* isbfile;
@property (nonatomic, retain) AVAudioPlayer* player;

@property (nonatomic, assign) NSInteger nPositionInCourse;
@property (nonatomic, retain) CourseParser* courseParser;
@property (nonatomic, assign) id<ListeningArticleViewControllerDelegate>delegate;
@property (nonatomic, retain) IBOutlet UIView* adView;
@property (nonatomic, retain) IBOutlet CollapseClick* collpaseLesson;

@property (nonatomic, retain) IBOutlet UIButton* readeButton;
@property (nonatomic, retain) IBOutlet UIButton* practiceButton;
@property (nonatomic, retain) IBOutlet UILabel* posLabel;

- (void)initMembers;
- (void)initDownload;
- (void)initValue;
- (void)parseWAVFile;
- (void)addWaitingView:(NSInteger)tag withText:(NSString*)text withAnimation:(BOOL)animated;
- (void)addLoadingView;
- (void)removeLoadingView;
- (void)addDownloadingView;
- (void)removeDownloadingView;
- (void)addDownloadingFailedView;
- (BOOL)downloadLesson;
//- (void)downloadLESByURL:(NSString *)url withTryIndex:(NSInteger)tryIndex;
//- (void)downloadXINByURL:(NSString*)url withTryIndex:(NSInteger)tryIndex;
//- (void)downloadISBByURL:(NSString *)url withTryIndex:(NSInteger)tryIndex;

- (void)displayLesson;
- (IBAction)clickReadLessonButton:(id)sender;
- (IBAction)clickReadingFollowButton:(id)sender;
- (void)beforePlayWholeLesson;
- (void)clearViewAndResetButtons;

- (void)playAnimationWithView:(UIView*)viewWillAnimation;
- (void)playfromCurrentPos;
- (void)updateUI;
- (void)finishedFllowMe;
- (void)finishReadingWholeText;

// player AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (NSString*)getRecordingFilePath:(NSInteger)nIndex;
- (void)checkTopRecording;

@end
