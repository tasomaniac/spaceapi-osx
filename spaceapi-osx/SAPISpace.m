//
//  SAPISpace.m
//  SpaceAPI
//
//  Created by Andreas Pfohl on 29.06.13.
//  Copyright (c) 2013 Andreas Pfohl. All rights reserved.
//

#import "SAPISpace.h"
#import "SAPIPreferenceController.h"

NSString * const SAPIOpenStatusChangedNotification = @"SAPIOpenStatusChanged";

@implementation SAPISpace {
    NSDictionary *_spaceData;
    NSOperationQueue *_workerQueue;
    NSTimer *_fetchTimer;
}

- (id)initWithName:(NSString *)name andAPIURL:(NSString *)apiURL
{
    self = [super init];
    if (self) {
        _workerQueue = [[NSOperationQueue alloc] init];
        self.name = name;
        self.apiURL = apiURL;
        [self setOpen:NO];

        _fetchTimer = [NSTimer scheduledTimerWithTimeInterval:[SAPIPreferenceController updateInterval] target:self selector:@selector(fetchTimerDo:) userInfo:nil repeats:NO];
    }

    return self;
}

- (IBAction)fetchTimerDo:(NSTimer *)aTimer
{
    [self fetchSpaceData];
    _fetchTimer = [NSTimer scheduledTimerWithTimeInterval:[SAPIPreferenceController updateInterval] target:self selector:@selector(fetchTimerDo:) userInfo:nil repeats:NO];
}

- (void)fetchSpaceData
{
    NSURL *spaceAPIUrl = [NSURL URLWithString:self.apiURL];
    NSURLRequest *spaceAPIRequest = [[NSURLRequest alloc] initWithURL:spaceAPIUrl];
    [NSURLConnection sendAsynchronousRequest:spaceAPIRequest queue:_workerQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data && !error) {
            NSError *jsonError;
            _spaceData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];

            if (!jsonError) {
                NSNumber *openStatus;
                NSString *statusMessage;
                NSString *version = [_spaceData objectForKey:@"api"];

                if (version) {
                    if ([version isEqualToString:@"0.11"] || [version isEqualToString:@"0.12"]) {
                        openStatus = [_spaceData objectForKey:@"open"];
                        statusMessage = [_spaceData objectForKey:@"status"];
                    } else {
                        openStatus = [[_spaceData objectForKey:@"state"] objectForKey:@"open"];
                        statusMessage = [[_spaceData objectForKey:@"state"] objectForKey:@"message"];
                    }

                    NSDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:openStatus forKey:@"openStatus"];
                    if (statusMessage) {
                        [userInfo setValue:statusMessage forKey:@"statusMessage"];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:SAPIOpenStatusChangedNotification object:self userInfo:userInfo];

                    [self setOpen:[openStatus boolValue]];
                }
            }
        }
    }];
}

@end
