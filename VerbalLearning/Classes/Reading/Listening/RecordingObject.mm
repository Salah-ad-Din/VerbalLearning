//
//  RecordingObject.m
//  Partners
//
//  Created by JiaLi on 13-6-13.
//  Copyright (c) 2013年 JiaLi. All rights reserved.
//

#import "RecordingObject.h"
#import <QuartzCore/QuartzCore.h>
#import "Word.h"
#import "isaybiosscroe.h"
#import "VoiceDef.h"
#import "NSPhoneticSymbol.h"

//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
char *OSTypeToStr(char *buf, OSType t)
{
	char *p = buf;
	char str[4] = {""}, *q = str;
	*(UInt32 *)str = CFSwapInt32(t);
	for (int i = 0; i < 4; ++i) {
		if (isprint(*q) && *q != '\\')
			*p++ = *q++;
		else {
			sprintf(p, "\\x%02x", *q++);
			p += 4;
		}
	}
	*p = '\0';
	return buf;
}

@implementation RecordingObject

+ (int)scoreForSentence:(Sentence*)sentence file:(NSString*)filename toResult:(NSMutableDictionary*)scoreDictionary
{
    // Score
    ISAYB6WORDSCORE * pWord;
    int nWord;
    int score;
    FILE* file = fopen([filename cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    
    fseeko(file, 0, SEEK_END);
    long fileLength = ftell(file);
    
    fseeko(file, 0, SEEK_SET);
    short *buffer = (short*)new char[fileLength];
    
    int n = fread(buffer, 1, fileLength, file);
    // 跳到data数据区
    int nOffset = 2046;
    
    if (strncmp((char*)&buffer[nOffset - 2], "data", 4) != 0) {
        char * p = (char*) &buffer[0];
        nOffset = 0;
        while (strncmp(p, "data", 4) != 0) {
            nOffset += 2;
            p += 4;
        }
        //        p += 4;
        nOffset += 2;
    }
    
    NSLog(@"%d, %d", n, nOffset);
    
    NSMutableString* orintext = [[NSMutableString alloc] init];
    for (int i = 0; i < [sentence.psDict count]; i++) {
        WordPhonetic* temp = [sentence.psDict objectAtIndex:i];
        [orintext appendString:@" "];
        [orintext appendString:temp.word];
    }
    
    [isaybios ISAYB_Recognition:[orintext cStringUsingEncoding:NSUTF8StringEncoding]
                           From:&buffer[nOffset]
                         Length:(n / 2) - nOffset
                             To: &pWord
                         Length: &nWord
                       AndScore: &score];
    
    delete[] buffer;
    if (pWord == nil) {
        return 0;
    }
    V_NSLog(@"分数：%d", score);

    NSMutableArray* wordArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [sentence.words count]; i++) {
        char* tWord = pWord[i].text;
        NSData *data = [NSData dataWithBytes:tWord length:strlen(tWord)];
        NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if (aStr != nil) {
            V_NSLog(@"%s 分数：%f", pWord[i].text, pWord[i].fScore);
            
            [wordArray addObject:aStr];
        }
        [aStr release];
    }
    // 对分数进行调整，以时间为准，调整20分。
    double time = 0.0;
    for(int i = 0;i < [sentence.words count]; i++)
    {
        Word* word = [sentence.words objectAtIndex:i];
        time += [word.endtime doubleValue] - [word.starttime doubleValue];
    }
    double rgTime = 0.0;
    for (int i = 0; i < nWord; i++) {
        rgTime += pWord[i].fTimeEd - pWord[i].fTimeSt;
    }
    int result = score - (fabs(time - rgTime) / time * 20);
    score = result > 0 ? result : score;
    
    V_NSLog(@"调整后的分数：%d", score);
    
    if (scoreDictionary != nil) {
        [scoreDictionary setObject:@(score) forKey:@"score"];
    }
    if (wordArray != nil) {
        [scoreDictionary setObject:wordArray forKey:@"words"];
        [wordArray release];
    }
    return score;
}
#pragma mark AudioSession listeners
void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState)
{
    RecordingObject *THIS = (RecordingObject*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) {
			[THIS stopRecord];
		}
	}
	/*RecordingViewController *THIS = (RecordingViewController*)inClientData;
     if (inInterruptionState == kAudioSessionBeginInterruption)
     {
     if (THIS->recorder->IsRunning()) {
     [THIS stopRecord];
     }
     else if (THIS->player->IsRunning()) {
     //the queue will stop itself on an interruption, we just need to update the UI
     [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
     THIS->playbackWasInterrupted = YES;
     }
     }
     else if ((inInterruptionState == kAudioSessionEndInterruption) && THIS->playbackWasInterrupted)
     {
     // we were playing back when we were interrupted, so reset and resume now
     THIS->player->StartQueue(true);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:THIS];
     THIS->playbackWasInterrupted = NO;
     }*/
}

void propListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inDataSize,
                  const void *            inData)
{
	RecordingObject *THIS = (RecordingObject*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{
			// stop the queue if we had a non-policy route change
			if (THIS->recorder->IsRunning()) {
				[THIS stopRecord];
			}
		}
	}
	else if (inID == kAudioSessionProperty_AudioInputAvailable)
	{
		if (inDataSize == sizeof(UInt32)) {
			//UInt32 isAvailable = *(UInt32*)inData;
			// disable recording if input is not available
			//THIS->btn_record.enabled = (isAvailable > 0) ? YES : NO;
		}
	}
}

- (void)stopRecord
{
	recorder->StopRecord();
}

- (id)init
{
    self = [super init];
    if (recorder == nil) {
        recorder = new AQRecorder();
    }
	//player = new AQPlayer();
    
	OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
	if (error) printf("ERROR INITIALIZING AUDIO SESSION! %ld\n", error);
	else
	{
		UInt32 category = kAudioSessionCategory_PlayAndRecord;
		error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
		if (error) printf("couldn't set audio category!");
        
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
		UInt32 inputAvailable = 0;
		UInt32 size = sizeof(inputAvailable);
		
		// we do not want to allow recording if input is not available
		error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
		if (error) printf("ERROR GETTING INPUT AVAILABILITY! %ld\n", error);
		// btn_record.enabled = (inputAvailable) ? YES : NO;
		
		// we also need to listen to see if input availability changes
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
        
		error = AudioSessionSetActive(true);
		if (error) printf("AudioSessionSetActive (true) failed");
	}
    return self;
}

- (void)start:(NSString*)recordFile
{
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:recordFile]) {
        [mgr removeItemAtPath:recordFile error:nil];
    }
    BOOL bOK = recorder->StartRecord(CFStringRef(recordFile));
    
    [self setFileDescriptionForFormat:recorder->DataFormat()];
    if (!bOK) {
        [self addFailedRecordingView:addInview];
        recorder->StopRecord();
        [NSTimer scheduledTimerWithTimeInterval: 3 target: self selector:@selector(removeFailedRecordingView) userInfo: nil repeats: NO];
    }
}

-(void)setFileDescriptionForFormat:(CAStreamBasicDescription)format
{
	char buf[5];
	const char *dataFormat = OSTypeToStr(buf, format.mFormatID);
	NSString* description = [[NSString alloc] initWithFormat:@"(%d ch. %s @ %g Hz)", (unsigned int)(format.NumberChannels()), dataFormat, format.mSampleRate, nil];
	//fileDescription.text = description;
	[description release];
}

- (void)addFailedRecordingView:(UIView*)toView;
{
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    loadingView.layer.cornerRadius = 8;
    loadingView.tag = FAILEDRECORDINGVIEW_TAG;
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    UILabel* loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingView.frame.size.width, 20)];
    loadingText.textColor = [UIColor whiteColor];
    loadingText.text = STRING_RECORDING_ERROR;
    loadingText.font = [UIFont systemFontOfSize:14];
    loadingText.backgroundColor = [UIColor clearColor];
    loadingText.textAlignment  = NSTextAlignmentCenter;
    loadingText.center = loadingView.center;
    [loadingView addSubview:loadingText];
    [loadingText release];
    loadingView.center = toView.center;
    [toView addSubview:loadingView];
    [loadingView release];
    
}

- (void)stop
{
  	recorder->StopRecord();
  
}

- (void)setAddInView:(UIView*)v;
{
    addInview = v;
}
@end
