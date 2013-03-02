//
//  WTFileManager.m
//  查查同济建筑
//
//  Created by 吴 wuziqi on 13-3-2.
//  Copyright (c) 2013年 吴 wuziqi. All rights reserved.
//

#import "WTFileManager.h"
#define kData @"data"

static WTFileManager *instance = NULL;
@interface WTFileManager()
@property (nonatomic, copy) NSString *filePath;
@end

@implementation WTFileManager
@synthesize historyArray = _historyArray;
@synthesize filePath = _filePath;

+ (WTFileManager *)defaultManager
{
    if (instance == NULL) {
        instance = [[WTFileManager alloc] init];
    }
    
    return instance;
}

- (void)loadHistoryFromFile:(NSString *)filename
{
    NSData *data = [NSData dataWithContentsOfFile:filename];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    self.historyArray = [[NSMutableArray alloc]initWithArray:[unarchiver decodeObjectForKey:kData]];
}

- (NSString *)configureFilePath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    
    return [path stringByAppendingPathComponent:filename];
}

- (void)loadFile:(NSString *)filename
{
    NSFileManager* manager = [NSFileManager defaultManager];
    self.filePath = [self configureFilePath:filename];
    
    if (![manager fileExistsAtPath:self.filePath]) {
        [manager createFileAtPath:self.filePath contents:nil attributes:nil];
    }
    
    [self loadHistoryFromFile:self.filePath];
}

- (void)save
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.historyArray forKey: kData];
    [archiver finishEncoding];
    
    [data writeToFile:self.filePath atomically:YES];
}

@end
