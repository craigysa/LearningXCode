//
//  CYCGameClock.h
//  HelloWorld
//
//  Created by Craig Young on 2013/10/30.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYCStopWatch.h"

typedef NS_ENUM(NSInteger, CYCClockState) {
    csPaused,
    csRunning
};

/* Class representing a clock used for timing moves in turn based games (e.g. chess).
 A single instance represents the time for a single player. Multiple instances (usually two) will 
 be combined to track time used by/available to each player. Using multiple clocks, a controller 
 will pause & start specific clocks in response to user actions.
    
 NOTE: Traditionally game clocks count-down the time remaining for each player, and when one 
    player runs out of time, the other may claim a win (or draw) on time.

    E.g. In a tournament chess game (each player will have a clock instance):
    - Both clocks will start paused set to the intial time control for the game. 
        (The times may be different for each player if handicap time controls are used.)
    - When the game starts, the first player's clock will be started.
    - After moving, the first player will press a button to simultaneously stop his clock, and 
        start the other.
    - The same will apply for the second player; and the players will alternate moves in this 
        fashion until the game ends.
    - Both clocks can be paused if the tournament director needs to be called.
    - The tournament director has the option to adjust the time of either clock with a 
        bonus/penalty in terms of the tournament rules.

    Another feature of tournament chess is that the time control rules may specify different time 
        constraints for different phases of the game. 
    E.g.
    - 90 minutes for the first 40 moves. After 40 moves, each player gets an extra 15 minutes, and 
        with each move, an extra 15 seconds.
    - The players can adjust the times after the first 40 moves.
    - However, the clock can also be programmed in advance to automatically make the adjustment.
    - More importantly, since it would be infeasible to manually add the bonus 15s per move, the 
        clock should be configured to do so automatically.
 */
@interface CYCGameClock : NSObject

/* A game clock needs a high-precision start/stop timer in order to accurately accumulate time 
    elapsed over a number of discrete intervals. Platform support for high-precision timers is 
    inconsistent, so dependency injection should be used to specify an appropriate start/stop 
    timer for the platform using the clock.
 */
+ (CYCGameClock *)gameClockWithStopWatch:(id <CYCStopWatch>) stopWatch;
- (CYCGameClock*)initWithStopWatch:(id <CYCStopWatch>) stopWatch;
@property (readonly, nonatomic) id <CYCStopWatch> stopWatch;

/* A clock instance is either paused or tracking the elapsed time.
 */
@property (readonly, nonatomic) CYCClockState state;

/* Some time control configurations require that the game clock keep track of the number of moves 
    played. E.g. A typical time control rule in chess is to add extra time for each player after 
    the first 40 moves of a game.
 */
@property (nonatomic) int moveCount;

/* Sets the current time to display on the clock.
NOTE: The convention of descriptively naming each attribute has been intentionally violated due to
    the extremely intuitive way in which this can be used to set the time.
    I.e. [clock setTime:1:30:00] //exactly mimics typical digital clock displays.
 */
- (void)setTime:(NSInteger)hours :(NSInteger)minutes :(NSInteger)seconds;
//- (void)addTime:(NSInteger)hours :(NSInteger)minutes :(NSInteger)seconds;
//- (void)reduceTime:(NSInteger)hours :(NSInteger)minutes :(NSInteger)seconds;
//- (void)setTimeWithInterval:(NSTimeInterval)timerInterval;

/* Attributes indicating the current time on the clock.
    currentTime: A floating-point value indicating the number of seconds.
        E.g. 1.1 ==> 1 second, 100 milliseconds
    hour: The hour value which should be displayed by the clock.
    minute: The minute value which should be displayed.
    second: The seconds value which should be displayed.
    millisecond: The millisecond value which can be displayed if that level of detail is desired.
 */
- (NSTimeInterval)currentTime;
@property (readonly, nonatomic) int hour;
@property (readonly, nonatomic) int minute;
@property (readonly, nonatomic) int second;
@property (readonly, nonatomic) int millisecond;

/* Start the clock running and accumulating more elapsed time for the player.
NOTE: Some time control rules may permit time to be automatically added to the clock at the start
    of a player's turn. 
 */
- (void)startMove;  //TODO: Do not grant the bonus time if a clock is being started after both
                    //clocks paused, or at start of game. A mechanism will be required to determine
                    //this.

/* Ends the current move and increments the move counter. */
- (void)endMove;

@end
