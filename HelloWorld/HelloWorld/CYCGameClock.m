//
//  CYCGameClock.m
//  HelloWorld
//
//  Created by Craig Young on 2013/10/30.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import "CYCGameClock.h"

@implementation CYCTimer
//-(void)startTimer;
//-(NSTimeInterval)stopTimer;
@end


@implementation CYCGameClock
    NSTimeInterval currentTime;
    CYCTimer *_timer;

+ (CYCGameClock *)initWithTimer:(CYCTimer*) timer;
{
    return [[CYCGameClock alloc] initWithTimer:timer];
}

- (id)initWithTimer:(CYCTimer*) timer;
{
    _timer = timer;
    return self;
}

- (id)init;
{
    _timer = [CYCTimer new];
    return self;
}

- (CYCTimer*)timer;
{
    return _timer;
}

- (void)setTime:(NSInteger)hours :(NSInteger)minutes :(NSInteger)seconds;
{
    int totalMinutes = hours * 60 + minutes;
    int totalSeconds = totalMinutes * 60 + seconds;
    currentTime = totalSeconds;
}

- (NSTimeInterval)currentTime; {
    return currentTime;
}

- (int)hour; {
    div_t h = div(currentTime, 3600);
    return h.quot;
}

- (int) totalSeconds; {
    return currentTime;
}

@end
