//
//  CYCStopWatch.m
//  HelloWorld
//
//  Created by Craig Young on 2013/11/04.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import "CYCStopWatch.h"
#import <sys/time.h>

@interface CYCStopWatch ()
@property (readwrite, nonatomic) BOOL running;
@end

@implementation CYCStopWatch {
    struct timeval _startTime;
    struct timeval _totalTime;
}

- (struct timeval)addRunningTime:(struct timeval)time; {
    struct timeval result;
    struct timeval currentTime;
    gettimeofday(&currentTime, NULL);

    result = time;
    if (self.running) {
        result.tv_sec += (currentTime.tv_sec - _startTime.tv_sec);
        result.tv_usec += (currentTime.tv_usec - _startTime.tv_usec);
    }
    return result;
}

- (void) start; {
    if (!self.running) {
        gettimeofday(&_startTime, NULL);
    }
    self.running = YES;
}

- (void) stop; {
    _totalTime = [self addRunningTime:_totalTime];
    self.running = NO;
}

- (NSTimeInterval) elapsedTime {
    struct timeval result = _totalTime;
    result = [self addRunningTime:result];

    return result.tv_sec + (double)result.tv_usec / 1000 / 1000;
}

- (void)reset {
    [self stop];
    _totalTime.tv_sec = 0;
    _totalTime.tv_usec = 0;
}

@end
