//
//  SettingData.m
//  Voice
//
//  Created by JiaLi on 11-8-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingData.h"
#import "VoiceDef.h"
#import "Globle.h"
@implementation SettingData

@synthesize dTimeInterval;
@synthesize nReadingCount;
@synthesize eShowTextType;
@synthesize eReadingMode;
@synthesize bLoop;
@synthesize bShowDay;
@synthesize version;
@synthesize isNeedCopyFreeSrc;
- (id)init
{
    self = [super init];
    if (self) {
        [self initSettingData];
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)initSettingData;
{
    self.dTimeInterval = kBufferDurationSeconds;
    self.nReadingCount = 1.0;
    self.eShowTextType = SHOW_TEXT_TYPE_SRC;
    self.bLoop = NO;
    self.bShowDay = YES;
    self.version = 0.0;
    self.isNeedCopyFreeSrc = YES;
}

- (void)loadSettingData;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [Globle getUserDataPath];
	
	path = [path stringByAppendingPathComponent:DIR_SETTING];
	if (![fileManager fileExistsAtPath:path isDirectory:nil])  
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];	
	
	NSString *settingPList = [path stringByAppendingPathComponent:FILE_SETTING_PLIST];
	[self initSettingData];
	
	// load general settings.
	BOOL hasFile;
	hasFile = [fileManager fileExistsAtPath:settingPList];
    
	if (!hasFile) {
		[fileManager createFileAtPath:settingPList contents:nil attributes:nil];
		[self saveSettingData];
	} else {
        NSMutableDictionary * tempsetting = [NSMutableDictionary dictionaryWithContentsOfFile:settingPList];
        NSNumber *timerValueTemp = [tempsetting objectForKey:kSettingTimeInterval];
        if (timerValueTemp != nil) {
			self.dTimeInterval = [timerValueTemp floatValue];
        }

        NSNumber *readingCountTemp = [tempsetting objectForKey:kSettingReadingCount];
        if (readingCountTemp != nil) {
			self.nReadingCount = [readingCountTemp intValue];
        }

        NSNumber *showTranslationTemp = [tempsetting objectForKey:kSettingisShowTranslation];
        if (showTranslationTemp != nil) {
			self.eShowTextType = [showTranslationTemp intValue];
        }
        NSNumber *readingModeTemp = [tempsetting objectForKey:kSettingReadingMode];
        if (readingModeTemp != nil) {
			self.eReadingMode = [readingModeTemp intValue];
        }
        
        NSNumber* loopTemp = [tempsetting objectForKey:kSettingLoopReading];
        if (loopTemp != nil) {
            self.bLoop = [loopTemp boolValue];
        }
        NSNumber* dayTemp = [tempsetting objectForKey:kSettingShowDay];
        if (dayTemp != nil) {
            self.bShowDay = [dayTemp boolValue];
        }
        NSNumber* versionTemp = [tempsetting objectForKey:kSettingVersion];
        if (versionTemp != nil) {
            self.version = [versionTemp floatValue];
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            if ([currentVersion floatValue] != self.version) {
                self.isNeedCopyFreeSrc = YES;
            } else {
                self.isNeedCopyFreeSrc = NO;
            }
           
        }
   
	}
}

- (void)saveSettingData;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [Globle getUserDataPath];
	
	path = [path stringByAppendingPathComponent:DIR_SETTING];
	if (![fileManager fileExistsAtPath:path isDirectory:nil])  
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];	
	
	path = [path stringByAppendingPathComponent:FILE_SETTING_PLIST];
	
	BOOL hasFile = [fileManager fileExistsAtPath:path];
	if (!hasFile) {
		[fileManager createFileAtPath:path contents:nil attributes:nil];
	}     
    NSMutableDictionary * settingdictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (settingdictionary == nil) {
        settingdictionary = [[NSMutableDictionary alloc] init];
    }
    [settingdictionary setObject:[NSNumber numberWithFloat:1.0] forKey:KSettingVersion];
    [settingdictionary setObject:[NSNumber numberWithFloat:self.dTimeInterval] forKey:kSettingTimeInterval];
    [settingdictionary setObject:[NSNumber numberWithInt:self.nReadingCount] forKey:kSettingReadingCount];
    [settingdictionary setObject:[NSNumber numberWithInt:self.eReadingMode] forKey:kSettingReadingMode];
    [settingdictionary setObject:[NSNumber numberWithInt:self.eShowTextType] forKey:kSettingisShowTranslation];
    [settingdictionary setObject:[NSNumber numberWithBool:self.bLoop] forKey:kSettingLoopReading];
    [settingdictionary setObject:[NSNumber numberWithBool:self.bShowDay] forKey:kSettingShowDay];
    [settingdictionary setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:kSettingVersion];
	[settingdictionary writeToFile:path atomically:YES];
    [settingdictionary release];
}

@end
