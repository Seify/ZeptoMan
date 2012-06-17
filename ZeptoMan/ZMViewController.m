//
//  ZMViewController.m
//  ZeptoMan
//
//  Created by Roman Smirnov on 16.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZMViewController.h"

@interface ZMViewController () 
{

}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation ZMViewController

@synthesize context = _context;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
        
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;

    [EAGLContext setCurrentContext:self.context];
    
    scene = [[ZMScene alloc] init];
    
    [self setupGL];
    
    UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeL];
    
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeR];
    
    UISwipeGestureRecognizer *swipeU = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeU.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeU];
    
    UISwipeGestureRecognizer *swipeD = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeD.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeD];
    
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)setupGL
{
    
    [scene setupGL];
    
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [scene tearDownGL];
}

#pragma mark - Gestures handlers
- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture
{
//    NSLog(@"%@ : %@ swipe = %@", self, NSStringFromSelector(_cmd), gesture);
    [scene swipe:gesture.direction];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture
{
//    NSLog(@"%@ : %@ swipe = %@", self, NSStringFromSelector(_cmd), gesture);
    [scene swipe:gesture.direction];
}

- (void)swipeUp:(UISwipeGestureRecognizer *)gesture
{
//    NSLog(@"%@ : %@ swipe = %@", self, NSStringFromSelector(_cmd), gesture);
    [scene swipe:gesture.direction];
}

- (void)swipeDown:(UISwipeGestureRecognizer *)gesture
{
//    NSLog(@"%@ : %@ swipe = %@", self, NSStringFromSelector(_cmd), gesture);
    [scene swipe:gesture.direction];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    
    [scene update:self.timeSinceLastUpdate];
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    [scene render];

}


@end
