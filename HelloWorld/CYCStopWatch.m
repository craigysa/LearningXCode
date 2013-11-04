//
//  CYCStopWatch.m
//  HelloWorld
//
//  Created by Craig Young on 2013/11/04.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import "CYCStopWatch.h"

@interface CYCStopWatch ()
@property (readwrite, nonatomic) BOOL running;
@end

@implementation CYCStopWatch

- (void) start; {
    self.running = YES;
}

- (void) stop; {
    self.running = NO;
}

- (NSTimeInterval) elapsedTime {
    return 0.0;
}

//-(NSTimeInterval)stopTimer;

@end
