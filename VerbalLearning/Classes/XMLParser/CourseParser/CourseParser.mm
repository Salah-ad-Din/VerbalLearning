//
//  CourseParser.m
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CourseParser.h"
#import "TBXML.h"
#import "Course.h"
#import "Lesson.h"
#import "Sentence.h"
#import "Teacher.h"
#import "Word.h"
#import "VoiceDef.h"

#import "isaybiosscroe.h"
#import "ISaybEncrypt2.h"
#import "SmartEncrypt.h"
#import "Database.h"
#import "CurrentInfo.h"
#import "BorrowInfo.h"
#import "Globle.h"
@implementation CourseParser

@synthesize resourcePath, tbxml, course;

// #define PRE_TRANSFER_PS

- (id)init
{
    course = nil;
#ifdef PRE_TRANSFER_PS
    psDict = [[NSPhoneticSymbol alloc]init];
    
#endif

    _psArray = [[NSMutableArray alloc] initWithArray:[PS_ARRAY componentsSeparatedByString:@","]];
    _psSrcArray = [[NSMutableArray alloc] initWithArray:[PS_CHAR_ARRAY componentsSeparatedByString:@","]];
    
    [super init];
    return self;
}

/*- (void)setResourcePath:(NSString *)resource
{
    resourcePath = resource;
    NSLog(@"%@", resourcePath);
}
*/

static bool bLoadModel = NO;
- (void)loadModel
{
    if (!bLoadModel) {
         NSString* strModel = [NSString stringWithFormat:@"%@/model.dat", [[NSBundle mainBundle] resourcePath]];
        bool ecode = [isaybios ISAYB_SetModel:[strModel cStringUsingEncoding:NSUTF8StringEncoding]];
        
        bLoadModel = YES;
    }
    
}


- (void)getMirrorRessourcePath
{
    if (wavePath == nil) {
        
        CurrentInfo* info = [CurrentInfo sharedCurrentInfo];
        NSString* fullFilename = [self.resourceSaveDataPath stringByAppendingFormat:@"%@/%@",info.currentPkgDataPath, info.currentPkgDataTitle];
        
        NSRange r = [fullFilename rangeOfString:STRING_VOICE_PKG_DIR];
        [Globle addSkipBackupAttributeToFile:fullFilename];
        if (r.length != 0) {
            NSString* dataPath = [fullFilename substringFromIndex:(r.location + r.length)];
            NSString *docsDir = [Globle getMirrorPath];
            wavePath = [[NSString alloc] initWithFormat:@"%@%@", docsDir, dataPath];

        }
    }
}




- (void)loadCourses:(NSString*)filename
{    
    [self loadModel];

	// Load and parse the index.xml file
    NSString* fullFilename = [resourcePath stringByAppendingPathComponent:filename];
    //NSLog(@"%@", fullFilename);
    NSData* filedata = [NSData dataWithContentsOfFile:fullFilename];
    NSString* strData = [[NSString alloc] initWithData:filedata encoding:NSUTF8StringEncoding];
    
    // 解析借阅信息
//    BorrowInfo* borrowInfo = [[BorrowInfo alloc]init];
//    NSInteger loc = [borrowInfo parseInfo:strData];
    
//    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:[borrowInfo date]];
    
//    V_NSLog(@"%@, 距离借阅时间：%f 小时", [borrowInfo.date description], time /3600);
//    [borrowInfo release];
    
//    NSString* strXML = [strData substringFromIndex:loc];
//    NSData* xmlData = [strXML dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* xmlData = [strData dataUsingEncoding:NSUTF8StringEncoding];

    
	tbxml = [[TBXML tbxmlWithXMLData:xmlData] retain];
	
	// Obtain root element
	TBXMLElement * root = tbxml.rootXMLElement;
	
	if (root) {
		TBXMLElement * body = [TBXML childElementNamed:@"body" parentElement:root];
		if (body) {
			if (!course) {
				course = [[Course alloc]init];
			}
			// metas
			TBXMLElement* metas = [TBXML childElementNamed:@"metas" parentElement:body];
			[self loadMetadata:metas];
			// lessons
			TBXMLElement* lessons = [TBXML childElementNamed:@"lessons" parentElement:body];
			[self loadLessons:lessons];
		}
		
	}
	[tbxml release];
	
}

/*
- (BOOL) isExpired:(NSString*)filename {
    [self loadModel];
    
	// Load and parse the index.xml file
    NSString* fullFilename = [resourcePath stringByAppendingPathComponent:filename];
    //NSLog(@"%@", fullFilename);
    NSData* filedata = [NSData dataWithContentsOfFile:fullFilename];
    NSString* strData = [[NSString alloc] initWithData:filedata encoding:NSUTF8StringEncoding];
    
    // 解析借阅信息
    BorrowInfo* borrowInfo = [[BorrowInfo alloc]init];
    [borrowInfo parseInfo:strData];
    
    //NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:[borrowInfo date]];
    
    //V_NSLog(@"%@, 距离借阅时间：%f 小时", [borrowInfo.date description], time /3600);
    if ([borrowInfo date]  == nil ) {
        return NO;
        
    }
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components: (NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit )
                                                        fromDate:[borrowInfo date]
                                                          toDate:[NSDate date]
                                                         options:0];
    
    
    NSLog(@"%d YEAR", [components year]);
    NSLog(@"%d MONTH", [components month]);
    NSLog(@"%d DAY", [components day]);
    NSLog(@"%d HOUR", [components hour]);
    NSLog(@"%d MINUTE", [components minute]);
    NSLog(@"%d HOUR", [components hour]);
    [borrowInfo release];
    return ([components year] > 0 || [components month] > 0 || [components day] > 30);
}
*/

- (void)loadMetadata:(TBXMLElement*)element
{
	if (element) {
		TBXMLElement* meta = [TBXML childElementNamed:@"meta" parentElement:element];
		while (meta) {
			// title
			TBXMLElement* title = [TBXML childElementNamed:@"title" parentElement:meta];
			if (title) {
				course.title = [TBXML textForElement:title];
			}
			// subject
			TBXMLElement* subject = [TBXML childElementNamed:@"subject" parentElement:meta];
			if (subject) {
				course.subject = [TBXML textForElement:subject];
			}
			// level
			TBXMLElement* level = [TBXML childElementNamed:@"level" parentElement:meta];
			if (level) {
				course.level = [[TBXML textForElement:level] integerValue];
			}
			// language
			TBXMLElement* language = [TBXML childElementNamed:@"language" parentElement:meta];
			if (language) {
				course.language = [TBXML textForElement:language];
			}
			
			meta = nil; // [TBXML nextSiblingNamed:@"meta" searchFromElement:meta];
		} 
	}
}

- (void)loadLessons:(TBXMLElement*)element
{
	if (element) {
		int lessonsCount = [[TBXML valueOfAttributeNamed:@"count" forElement:element] integerValue];
		course.lessons = [[NSMutableArray alloc]initWithCapacity:lessonsCount];
		
		TBXMLElement* lessonElement = [TBXML childElementNamed:@"lesson" parentElement:element];
		while (lessonElement) {
			Lesson* lesson = [[Lesson alloc]init];
			lesson.title = [TBXML valueOfAttributeNamed:@"title" forElement:lessonElement];
			lesson.lessonid = [TBXML valueOfAttributeNamed:@"id" forElement:lessonElement];
			lesson.order = [[TBXML valueOfAttributeNamed:@"order" forElement:lessonElement] integerValue];
			lesson.path = [TBXML valueOfAttributeNamed:@"path" forElement:lessonElement];
			lesson.file = [TBXML valueOfAttributeNamed:@"file" forElement:lessonElement];
			[course.lessons addObject:lesson];
			lessonElement = [TBXML nextSiblingNamed:@"lesson" searchFromElement:lessonElement];
		}
	}
}


- (void)loadLesson:(NSInteger)lessonindex
{
    Lesson* lesson = [course.lessons objectAtIndex:lessonindex];
    // is parsed?
    if (lesson.bParsed) {
        return;
    }
    
	if (lessonindex < [course.lessons count]) {
		// load file
        CurrentInfo* info = [CurrentInfo sharedCurrentInfo];
        NSString* fullFilename = [self.resourceSaveDataPath stringByAppendingFormat:@"%@/%@/%@",info.currentPkgDataPath, info.currentPkgDataTitle, lesson.path];
        
        fullFilename = [fullFilename stringByAppendingPathComponent:lesson.lessonid];
        
        // Load Lesson
        NSString *les = [NSString stringWithFormat:@"%@.les", fullFilename];
        NSLog(@"%@", les);
       [isaybios ISAYB_SetLesson:[les cStringUsingEncoding:NSUTF8StringEncoding]];
        
        // 读取加密xml
        NSString* xatFile = [fullFilename stringByAppendingPathExtension:@"xat"];
        const char* infile = [xatFile cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char* filedata = nil;
        Database* base = [Database sharedDatabase];
        LibaryInfo* libinfo = [base getLibaryInfoByID:info.currentLibID];
        /*if (!(libinfo.lisence != nil  && libinfo.lisenceLen != 0) || libinfo == nil) {
            return;
        }*/
        
        long nLen = LoadDecodeBuffer(infile, &filedata, (const unsigned char*)[libinfo.lisence cStringUsingEncoding:NSASCIIStringEncoding], libinfo.lisenceLen);
        
        tbxml = [[TBXML tbxmlWithXMLData:[NSData dataWithBytes:filedata length:nLen]] retain];
        //tbxml = [[TBXML tbxmlWithXMLFile:xatFile] retain];
        //FreeBuffer(&filedata);
		
		TBXMLElement* root = tbxml.rootXMLElement;
		if (root) {
			TBXMLElement* body = [TBXML childElementNamed:@"body" parentElement:root];
			if (body) {
				// load sentences
				TBXMLElement* textStream = [TBXML childElementNamed:@"textstream" parentElement:body];
				if (textStream) {
					lesson.setences = [[NSMutableArray alloc] init];
					[self loadSentence:textStream to:lesson.setences];
				}
				// load teachers
				TBXMLElement* teachers = [TBXML childElementNamed:@"teachers" parentElement:body];
				if (teachers) {
					lesson.teachers = [[NSMutableArray alloc] init];
					[self loadTeacher:teachers to:lesson.teachers];
				}
				// get wav file
				TBXMLElement* media = [TBXML childElementNamed:@"media" parentElement:body];
				if (media) {
					TBXMLElement* file = [TBXML childElementNamed:@"file" parentElement:media];
					if (file) {
						//lesson.wavfile = [resourcePath stringByAppendingPathComponent: [TBXML valueOfAttributeNamed:@"src" forElement:file]];
                        
                        NSString* filePath = [TBXML valueOfAttributeNamed:@"src" forElement:file];                    
                        NSString* fileName = [filePath substringToIndex:(filePath.length - 4)];
                        
                       [self getMirrorRessourcePath];
                        
						lesson.wavfile = [wavePath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"wav"]];
                        //NSLog(@"%@", lesson.wavfile);
                        
                        CurrentInfo* info = [CurrentInfo sharedCurrentInfo];
                        NSString* fullFilename = [self.resourceSaveDataPath stringByAppendingFormat:@"%@/%@",info.currentPkgDataPath, info.currentPkgDataTitle];
                        lesson.isbfile = [fullFilename stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"isb"]];
                        //NSLog(@"%@", lesson.isbfile);
                        
					}
				}
                lesson.bParsed = YES;
			}
		}
		[tbxml release];
	}
}
 

- (void)loadSentence:(TBXMLElement *)element to:(NSMutableArray *)sentences
{
	if (element) {
		// paragraph
		TBXMLElement* para = [TBXML childElementNamed:@"p" parentElement:element];
		while (para) {
			TBXMLElement* sentenceEle = [TBXML childElementNamed:@"s" parentElement:para];
			while (sentenceEle) {
				Sentence* sentence = [[Sentence alloc] init];
				sentence.starttime = [TBXML valueOfAttributeNamed:@"st" forElement:sentenceEle];
				sentence.endtime = [TBXML valueOfAttributeNamed:@"et" forElement:sentenceEle];
				sentence.techerid = [TBXML valueOfAttributeNamed:@"t" forElement:sentenceEle];
				// 原文
                TBXMLElement* orintext = [TBXML childElementNamed:@"ot" parentElement:sentenceEle];
				if (orintext) {
					sentence.orintext = [TBXML textForElement:orintext];
				}
                // 译文
				TBXMLElement* transtext = [TBXML childElementNamed:@"tt" parentElement:sentenceEle];
				if (transtext) {
					sentence.transtext = [TBXML textForElement:transtext];
				}
                // 音标
				TBXMLElement* ps = [TBXML childElementNamed:@"ps" parentElement:sentenceEle];
				if (ps) {
                    // 分词
                    sentence.psDict = [[NSMutableArray alloc] init];
                    NSString* psStr = [TBXML textForElement:ps];
                    NSRange separat = [psStr rangeOfString:@","];
                    while (separat.length > 0 || psStr.length > 0) {
                        NSString* psTemp = psStr;
                        if (separat.length > 0) {
                            psTemp = [psStr substringToIndex:separat.location];
                        }
                        NSRange colon = [psTemp rangeOfString:@":"];
                        if (colon.length > 0) {
                            NSString* strPS = [psTemp substringFromIndex:colon.location + 1];
#ifdef PRE_TRANSFER_PS
                            strPS = [psDict getPhoneticSymbol:strPS];
#else
                            //strPS = [self convertpsChar:strPS];
#endif
                            WordPhonetic* wordPhonetic = [[WordPhonetic alloc] init];
                            wordPhonetic.word = [psTemp substringToIndex:colon.location];
                            wordPhonetic.phonetic = strPS;
#ifdef PRE_TRANSFER_PS
                            [strPS release];
#endif
                            [sentence.psDict addObject:wordPhonetic];
                        }
                        // next
                        if (separat.length == 0) {
                            break;
                        }
                        psStr = [psStr substringFromIndex:(separat.location + 1)];
                        separat = [psStr rangeOfString:@","];
                    }
 				}
                // 单词位置
                TBXMLElement* wordsEle = [TBXML childElementNamed:@"tw" parentElement:sentenceEle];
                if (wordsEle) {
                    sentence.words = [[NSMutableArray alloc] init];
                    [self loadWord:wordsEle to:sentence.words];
                }
                
				[sentences addObject:sentence];
				sentenceEle = [TBXML nextSiblingNamed:@"s" searchFromElement:sentenceEle];
			}
			para = [TBXML nextSiblingNamed:@"p" searchFromElement:para];
		}
	}
}

- (void) loadTeacher:(TBXMLElement *)element to:(NSMutableArray *)teachers
{
	if (element) {
		TBXMLElement* teacherEle = [TBXML childElementNamed:@"teacher" parentElement:element];
		while (teacherEle) {
			Teacher* teacher = [[Teacher alloc] init];
			teacher.teacherid = [TBXML valueOfAttributeNamed:@"id" forElement:teacherEle];
			TBXMLElement* surname = [TBXML childElementNamed:@"surname" parentElement:teacherEle];
			teacher.surname = [TBXML textForElement:surname];
			TBXMLElement* name = [TBXML childElementNamed:@"name" parentElement:teacherEle];
			teacher.name = [TBXML textForElement:name];
			TBXMLElement* description = [TBXML childElementNamed:@"description" parentElement:teacherEle];
			teacher.description = [TBXML textForElement:description];
			TBXMLElement* gender = [TBXML childElementNamed:@"gender" parentElement:teacherEle];
			teacher.gender = [TBXML textForElement:gender];
			TBXMLElement* avatar = [TBXML childElementNamed:@"avatar" parentElement:teacherEle];
			teacher.avatar = [TBXML textForElement:avatar];
			[teachers addObject:teacher];
			teacherEle = [TBXML nextSiblingNamed:@"teacher" searchFromElement:teacherEle];
		}
	}
}

- (void) loadWord:(TBXMLElement *)element to:(NSMutableArray *)words
{
    if (element) {
        TBXMLElement* wordEle = [TBXML childElementNamed:@"w" parentElement:element];
        while (wordEle) {
            Word* word = [[Word alloc] init];
            word.starttime = [TBXML valueOfAttributeNamed:@"st" forElement:wordEle];
            word.endtime = [TBXML valueOfAttributeNamed:@"et" forElement:wordEle];
            word.fayin = [[TBXML valueOfAttributeNamed:@"fy" forElement:wordEle] floatValue];
            word.jiezou = [[TBXML valueOfAttributeNamed:@"sc" forElement:wordEle] floatValue];
            word.yinliang = [[TBXML valueOfAttributeNamed:@"yl" forElement:wordEle] floatValue];
            word.yingao = [[TBXML valueOfAttributeNamed:@"yg" forElement:wordEle] floatValue];
            TBXMLElement* text = [TBXML childElementNamed:@"text" parentElement:wordEle];
            word.text = [TBXML textForElement:text];
            [words addObject:word];
            wordEle = [TBXML nextSiblingNamed:@"w" searchFromElement:wordEle];
        }
    }
}

- (void)dealloc {
	
	for (int i = 0; i < [course.lessons count]; i++) {
		[[course.lessons objectAtIndex:i] release];
	}
	[course.lessons release];
	[psDict release];
    [_psArray release];
    [_psSrcArray release];
    [super dealloc];
}

- (NSString*) convertpsChar:(NSString*)str
{
    if (str == nil) {
        return str;
    }
    NSString* convertString = [NSString stringWithFormat:@"%@", str];
    if (([_psArray count] != [_psSrcArray count]) && ([_psSrcArray count] == 0)) {
        return str;
    }
    for (NSInteger i = 0; i < [_psArray count]; i++) {
        convertString = [convertString stringByReplacingOccurrencesOfString:[_psSrcArray objectAtIndex:i] withString:[_psArray objectAtIndex:i]];
    }
    convertString = [convertString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return convertString;
}
@end
