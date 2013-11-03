//
//  HelloWorldViewController.m
//  HelloWorld
//
//  Created by Craig Young on 2013/10/13.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import "HelloWorldViewController.h"

@interface HelloWorldViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UILabel *greetingOutput;
- (IBAction)changeGreeting:(id)sender;
- (IBAction)sayGoodbye:(id)sender;

@end

@implementation HelloWorldViewController
@synthesize middleButton = _middleButton; //Explicit synthesis is possible but usually unnecessary. E.g. If accessors have been explicitly overriden, compiler cannot automatically know that the fields are still needed.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CALayer *roundedButtonLayer = [self.roundedButton layer];
    [roundedButtonLayer setMasksToBounds:YES];
    [roundedButtonLayer setCornerRadius:5.0f];
    redButton.transform = CGAffineTransformMakeRotation(degreesToRadian(180));
    self.middleButton.transform = CGAffineTransformMakeRotation(degreesToRadian(45)); //Stangely it seems not all values work?! E.g. 90 deg just displays a few dots. 50 deg button disappears
    self.roundedButton.transform = CGAffineTransformMakeRotation(degreesToRadian(180));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.nameInput) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (NSString*)greeting; {
    NSString *whomToGreet = self.yourName;
    if ([whomToGreet length] == 0) {
        whomToGreet = @"World!";
    }
    return [[NSString alloc] initWithFormat:@"Hello %@ :)", whomToGreet];
}

- (IBAction)changeGreeting:(id)sender {
    self.yourName = self.nameInput.text;

    self.greetingOutput.text = self.greeting;
}

- (IBAction)sayGoodbye:(id)sender {
    self.yourName = self.nameInput.text;

    NSString *whomToGreet = self.yourName;
    if ([self.yourName length] == 0) {
        whomToGreet = @"Cruel World!";
    }
    self.greetingOutput.text = [[NSString alloc] initWithFormat:@"Goodbye %@ :(", whomToGreet];
}
@end
