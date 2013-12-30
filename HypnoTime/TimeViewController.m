//
//  TimeViewController.m
//  HypnoTime
//
//  Created by joeconway on 8/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    // Call the superclass's designated initializer
 // Get a pointer to the application bundle object
    NSBundle *appBundle = [NSBundle mainBundle];
    
    self = [super initWithNibName:@"TimeViewController"
                           bundle:appBundle];
                           
    if (self) {
        // Get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        // Give it a label
        [tbi setTitle:@"Time"];

        UIImage *i = [UIImage imageNamed:@"Time.png"];
        [tbi setImage:i];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"CurrentTimeViewController will appear");
    [super viewWillAppear:animated];
    [self showCurrentTime:nil];
    

    CGPoint originalPos = [askTimeBtn center];
    CGPoint startPos = CGPointMake(-10, originalPos.y);
    
    CABasicAnimation *slide = [CABasicAnimation animationWithKeyPath:@"position"];
    [slide setFromValue:[NSValue valueWithCGPoint:startPos]];
    [slide setToValue:[NSValue valueWithCGPoint:originalPos]];
    
    [slide setDuration:0.5];
    [[askTimeBtn layer] addAnimation:slide forKey:@"slideButtonAnimation"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"CurrentTimeViewController will DISappear");
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"Unloading TimeViewController's subviews %@", timeLabel);
//    timeLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TimeViewController loaded its view.");
    [[self view] setBackgroundColor:[UIColor greenColor]];  
}

- (IBAction)showCurrentTime:(id)sender
{
    NSDate *now = [NSDate date];
    // Static here means "only once." The variable formatter
    // is created when the program is first loaded into memory.
    // The first time this method runs, formatter will
    // be nil and the if-block will execute, creating
    // an NSDateFormatter object that formatter will point to.
    // Subsequent entry into this method will reuse the same
    // NSDateFormatter object.
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    [timeLabel setText:[formatter stringFromDate:now]];
    
    //[self spinTimeLabel];
    [self bounceTimeLabel];
}

- (void)bounceTimeLabel
{
    // Create a key frame animation
    CAKeyframeAnimation *bounce =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    // Create the values it will pass though
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    [bounce setValues:[NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                      [NSValue valueWithCATransform3D:forward],
                      [NSValue valueWithCATransform3D:back],
                      [NSValue valueWithCATransform3D:forward2],
                      [NSValue valueWithCATransform3D:back2],
                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                      nil]];
    
    // Create a key fram animation
    CAKeyframeAnimation *fade =
    [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    NSNumber *forwardOpacity = [NSNumber numberWithFloat:1];
    NSNumber *backOpacity = [NSNumber numberWithFloat:0];
    NSNumber *forwardOpacity2 = [NSNumber numberWithFloat:1];
    NSNumber *backOpacity2 = [NSNumber numberWithFloat:0];
    [fade setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0]
                       ,forwardOpacity, backOpacity, forwardOpacity2, backOpacity2,
                       [NSNumber numberWithFloat:1],nil]];
    
    // Set the duration
    [bounce setDuration:1];
    [fade setDuration:1];
    
    // Animate the layer
    [[timeLabel layer] addAnimation:bounce forKey:@"bounceAnimation"];
    [[timeLabel layer] addAnimation:fade forKey:@"fadeAnimation"];
}

- (void)spinTimeLabel
{
    // Create a basic animation
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setDelegate:self];
    
    // fromValue is implied
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 2.0]];
    [spin setDuration:1.0];
    
    // Set the timing function
    //CAMediaTimingFunction *tf = [CAMediaTimingFunction
    //                             functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAMediaTimingFunction *tf = [CAMediaTimingFunction
                           functionWithName:kCAMediaTimingFunctionEaseOut];
    [spin setTimingFunction:tf];
    
    // Kick off the animation by adding it to the layer
    [[timeLabel layer] addAnimation:spin forKey:@"spinAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%@ finished: %d", anim, flag);
}


@end
