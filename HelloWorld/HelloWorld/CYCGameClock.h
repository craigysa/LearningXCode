//
//  CYCGameClock.h
//  HelloWorld
//
//  Created by Craig Young on 2013/10/30.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ClockState) {
    csPaused,
    csRunning
};

@interface CYCTimer : NSObject
//-(void)startTimer;
//-(NSTimeInterval)stopTimer;
@end

@interface CYCGameClock : NSObject
@property (readonly) int state;
@property (readonly) int hour;
@property (strong, readonly) CYCTimer *timer;
+ (CYCGameClock *)initWithTimer:(CYCTimer*) timer;
- (void)setTime:(NSInteger)hours :(NSInteger)minutes :(NSInteger)seconds;
- (NSTimeInterval)currentTime;
- (int) totalSeconds;
@end
