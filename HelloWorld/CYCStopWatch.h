//
//  CYCStopWatch.h
//  HelloWorld
//
//  Created by Craig Young on 2013/11/04.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import <Foundation/Foundation.h>

/* This protocol defines the interface for a high-precision stop/start timer.
    The specific options available to support high-precision timing may vary between platforms, so this provides an opportunity to adopt various platform specific implementations.
 */
@protocol CYCStopWatch <NSObject>
@property (readonly, nonatomic) BOOL running;
@property (readonly, nonatomic) NSTimeInterval elapsedTime;
- (void)start;
- (void)stop;
@end

/* Class defining a default implementation of the CYCStopWatch protocol. */
@interface CYCStopWatch : NSObject <CYCStopWatch>
@property (readonly, nonatomic) BOOL running;
@property (readonly, nonatomic) NSTimeInterval elapsedTime;
//-(void)startTimer;
//-(NSTimeInterval)stopTimer;
@end
