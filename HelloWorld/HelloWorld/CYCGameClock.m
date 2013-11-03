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

@interface CYCGameClock ()
@property (readwrite, nonatomic) CYCTimer *timer;
@end

@implementation CYCGameClock {
    NSTimeInterval currentTime;
}

+ (CYCGameClock *)gameClockWithTimer:(CYCTimer*) timer; {
    return [[CYCGameClock alloc] initWithTimer:timer];
}

- (id)initWithTimer:(CYCTimer*) timer; {
    self = [super init];

    //This technique (prescribed by Apple) makes every pragmatic bone in my body cringe.
    //If **any** init method "fails" - that should surely be considered a **serious** problem???!
    //If init methods can return nil, then the entire system can be infested with "nil objects" floating around resulting in lots of other code unexpectedly failing unless it checks for nils on everything it does.
    //I most certainly **DO NOT** want to double the size of my code by double-checking that code I called worked correctly - I **expect** it to work correctly, and if it doesn't - it needs to be fixed!!
    //Finally, surely the purpose of <alloc> is to make certain <self> is assigned? It is somewhat unexpected for <initXXX> methods to be changing that?!
    if (self) {
        _timer = timer;
    }

    return self;
}

- (id)init; {
    return [self initWithTimer:[CYCTimer new]];
}

- (CYCTimer*)timer; {
    return _timer;
}

- (void)setTime:(NSInteger)hours :(NSInteger)minutes :(NSInteger)seconds; {
    int totalMinutes = hours * 60 + minutes;
    int totalSeconds = totalMinutes * 60 + seconds;
    currentTime = totalSeconds;
}

- (void)start; {
    _state = csRunning;
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
