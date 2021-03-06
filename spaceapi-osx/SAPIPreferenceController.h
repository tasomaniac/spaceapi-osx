//
//  SAPIPreferenceController.h
//  SpaceAPI
//
//  Created by Andreas Pfohl on 28.06.13.
//  Copyright (c) 2013 Andreas Pfohl. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const SAPIUpdateIntervalKey;
extern NSString * const SAPISelectedSpaceKey;

@interface SAPIPreferenceController : NSWindowController

@property (weak) IBOutlet NSTextField *intervalField;

+ (long)updateInterval;
+ (void)setUpdateInterval:(long)interval;

+ (NSString *)selectedSpace;
+ (void)setSelectedSpace:(NSString *)spaceName;

- (IBAction)changeUpdateInterval:(NSTextField *)sender;

@end
