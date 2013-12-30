//
//  HypnosisView.m
//  Hypnosister
//
//  Created by joeconway on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HypnosisView.h"

@implementation HypnosisView
@synthesize circleColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCircleColor:[UIColor lightGrayColor]];
        
        // Create the new layer object
        boxLayer = [[CALayer alloc] init];
        backgroundLayer = [[CALayer alloc] init];
        
        // Give it a size
        [boxLayer setBounds:CGRectMake(0.0, 0.0, 100.0, 100.0)];
        [backgroundLayer setBounds:CGRectMake(0.0, 0.0, 100.0, 100.0)];
        
        // Give it a location
        [backgroundLayer setPosition:CGPointMake(160, 100)];
        [boxLayer setPosition:CGPointMake(50.0, 50.0)];
        
        // Make half-transparent red the background color for the layer
        UIColor *reddish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        UIColor *whitish = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        
        // Get a CGColor object with the same color values
        CGColorRef cgReddish = [reddish CGColor];
        CGColorRef cgWhitish = [whitish CGColor];
        [backgroundLayer setBackgroundColor:cgWhitish];
        [boxLayer setBackgroundColor:cgReddish];
        
        // Create a UIImage
        UIImage *layerImage = [UIImage imageNamed:@"Hypno.png"];
        
        // Get the underlying CGImage
        CGImageRef image = [layerImage CGImage];
        
        // Put the CGImage on the layer
        [boxLayer setContents:(__bridge id)image];
        
        // Insert the image a bit on each side
        // http://forums.bignerdranch.com/viewtopic.php?f=235&t=4300
        //[boxLayer setContentsRect:CGRectMake(-0.5, -0.5, 1, 1)];
        //[boxLayer setContentsRect:CGRectMake(0, 0, 1, 1)];
        [boxLayer setContentsRect:CGRectMake(-0.5, -0.5, 2, 2)];
        
        // Let the image resize (without changing the aspect ratio)
        // to fill the contentRect
        [boxLayer setContentsGravity:kCAGravityResizeAspect];
        
        [boxLayer setCornerRadius:20];
        //[boxLayer setMasksToBounds:YES]; // this is used to cut the shadow of boxLayer
        
        [backgroundLayer setCornerRadius:20];
        //[backgroundLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        [backgroundLayer setBackgroundColor:[[UIColor redColor] CGColor]];
        [boxLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        [backgroundLayer setOpacity:0.5];
        //[backgroundLayer setCornerRadius:20];
        //[backgroundLayer setMasksToBounds:YES];
        
        [backgroundLayer setShadowColor:[[UIColor blueColor] CGColor]];
        [backgroundLayer setShadowOffset:CGSizeMake(10, 10)];
        [backgroundLayer setShadowOpacity:1];
        [backgroundLayer setShadowRadius:3];
        

        
        // Make it a sublayer of the view's layer
        [backgroundLayer addSublayer:boxLayer];
        [[self layer] addSublayer:backgroundLayer];
    }
    
    return self;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(motion == UIEventSubtypeMotionShake) {
        NSLog(@"Device started shaking!");
        [self setCircleColor:[UIColor redColor]];
    }
}

- (void)setCircleColor:(UIColor *)clr 
{
    circleColor = clr;
    [self setNeedsDisplay];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)drawRect:(CGRect)dirtyRect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];

    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The radius of the circle should be nearly as big as the view 
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    // The thickness of the line should be 10 points wide 
    CGContextSetLineWidth(ctx, 10);
    
    [[self circleColor] setStroke];
    
    // Draw concentric circles from the outside in
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        CGContextAddArc(ctx, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
        
        CGContextStrokePath(ctx);
    }
 
    // Create a string
    NSString *text = @"You are getting sleepy.";

    // Get a font to draw it in
    UIFont *font = [UIFont boldSystemFontOfSize:28];

    CGRect textRect;
    
    // How big is this string when drawn in this font?
    textRect.size = [text sizeWithFont:font];
    
    // Let's put that string in the center of the view
    textRect.origin.x = center.x - textRect.size.width / 2.0;
    textRect.origin.y = center.y - textRect.size.height / 2.0;

    // Set the fill color of the current context to black 
    [[UIColor blackColor] setFill];

    // The shadow will move 4 points to the right and 3 points down from the text
    CGSize offset = CGSizeMake(4, 3);

    // The shadow will be dark gray in color
    CGColorRef color = [[UIColor darkGrayColor] CGColor];

    // Set the shadow of the context with these parameters,
    // all subsequent drawing will be shadowed
    CGContextSetShadowWithColor(ctx, offset, 2.0, color);

    // Draw the string
    [text drawInRect:textRect
            withFont:font];   
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    [backgroundLayer setPosition:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [backgroundLayer setPosition:p];
    
    [CATransaction commit];
}
@end
