//
//  SAPIAppDelegate.h
//  SpaceAPI
//
//  Created by Andreas Pfohl on 28.06.13.
//  Copyright (c) 2013 Andreas Pfohl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SAPIAppController.h"

@interface SAPIAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet SAPIAppController *controller;

@end
