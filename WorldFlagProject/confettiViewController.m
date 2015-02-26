//
//  ViewController.m
//  Particle System
//
//  Created by RANJEET ANAND on 20/07/13.
//  Blog:   http://ranjeetanand.wordpress.com
//  Website:http://www.GrouchyGremlins.com

/*
 * Copyright (c) 2013 Ranjeet Anand.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
#import "confettiViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation confettiViewController {
    CAEmitterLayer *emitterLayer;
    BOOL isExploding;
}


//===============================================================
//This starts the explosion process with predefined particle
//intensity (for confetti it is twice that of gold stars)
//===============================================================
-(void) startExplosion{
    isExploding = YES;
    [emitterLayer setValue:[NSNumber numberWithInt:PARTICLE_INTENSITY * 0.3] forKeyPath:@"emitterCells.goldstar.birthRate"];
    [emitterLayer setValue:[NSNumber numberWithInt:PARTICLE_INTENSITY * 0.03] forKeyPath:@"emitterCells.confetti.birthRate"];
    [emitterLayer setValue:[NSNumber numberWithInt:PARTICLE_INTENSITY * 0.03] forKeyPath:@"emitterCells.trophyCell.birthRate"];
}



//===============================================================
//This stops explosion by setting birthRate to 0
//===============================================================
-(void) stopExplosion{
    [emitterLayer setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.goldstar.birthRate"];
    [emitterLayer setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.confetti.birthRate"];
    [emitterLayer setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.trophyCell.birthRate"];
    isExploding = NO;
}



//===============================================================
//This method is called immediately when user taps and emitter's
//position is set to the location of tap
//===============================================================
-(void) updateEmitterLayerPositionTo:(CGPoint) pos{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    emitterLayer.emitterPosition = pos;
    [CATransaction commit];
}



//===============================================================
//Creates emitter layer and set up its properties
//===============================================================
-(void) setupEmitter:(UIViewController*)vc{
    
    //At the begining there is no explosion. It happens only when user taps on the screen
    isExploding = NO;
    
    //Create an instance of CAEmitterLayer
    emitterLayer = [CAEmitterLayer layer];
    
    //Set the bounds to be full screen
    emitterLayer.bounds = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
    
    //Place it at the center
    emitterLayer.position = CGPointMake(vc.view.frame.size.width/2, vc.view.frame.size.height/2);
    
    //Set the background color to be dark teal
    //emitterLayer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.2 blue:0.2 alpha:1.0] CGColor];
    
    //Initial position of the emitter which will actually be reset to the location where the user taps
    emitterLayer.emitterPosition = CGPointZero;
    
    //Size of Emitter
    emitterLayer.emitterSize = CGSizeMake(100, 100);
    
    //Add it as sublayer of the main view's layer
    [vc.view.layer addSublayer:emitterLayer];
    
}



//===============================================================
//Creates emitter cells and set up its properties
//===============================================================
-(void) setupEmitterCells{
    
    //============== EMITTER CELL 1 - Gold Star ==============
    
    //Create Cell
    CAEmitterCell * goldStarCell = [CAEmitterCell emitterCell];
    
    //Name is nessary to access this cell using Key-Value-Coding (KVC)
    goldStarCell.name = @"goldstar";
    
    //Image used for the cell
    goldStarCell.contents = (id) [[UIImage imageNamed:@"icon_star-gold.png"] CGImage];
    
    //Number of particles per second
    goldStarCell.birthRate = 0;
    
    //Life in seconds
    goldStarCell.lifetime = 0.5;;
    goldStarCell.lifetimeRange = 0.6;
    
    //Magnitude of initial veleocity with which particles travel
    goldStarCell.velocity = 300;
    
    //Radial direction of emission of the particles
    goldStarCell.emissionRange = 2 * M_PI;
    
    //Spin (angular velocity) of the particles in radians per sec
    goldStarCell.spin = 0.0;
    goldStarCell.spinRange = 4 * M_PI;
    
    //Scaling of the particles
    goldStarCell.scale = 1.0;
    goldStarCell.scaleRange = 1.0;
    
    
    //============== EMITTER CELL 1 - Trophy  ==============
    
    //Create Cell
    CAEmitterCell * trophyCell = [CAEmitterCell emitterCell];
    
    //Name is nessary to access this cell using Key-Value-Coding (KVC)
    trophyCell.name = @"trophyCell";
    
    //Image used for the cell
    trophyCell.contents = (id) [[UIImage imageNamed:@"icon_Trophy-50.png"] CGImage];
    
    //Number of particles per second
    trophyCell.birthRate = 20;
    
    //Life in seconds
    trophyCell.lifetime = 4.5;
    trophyCell.lifetimeRange = 12.0;
    
    //Magnitude of initial veleocity with which particles travel
    trophyCell.velocity = 300;
    
    //Radial direction of emission of the particles
    trophyCell.emissionRange = 2 * M_PI;
    
    //Spin (angular velocity) of the particles in radians per sec
    trophyCell.spin = 0.0;
    trophyCell.spinRange = 4 * M_PI;
    
    //Scaling of the particles
    trophyCell.scale = 1.0;
    trophyCell.scaleRange = 1.0;
    
    
    //============== EMITTER CELL 2 - Confetti ==============
    
    //Create cell
    CAEmitterCell * confettiCell = [CAEmitterCell emitterCell];
    
    //Name is nessary to access this cell using Key-Value-Coding (KVC)
    confettiCell.name = @"confetti";
    
    //Image used for the cell
    confettiCell.contents = (id) [[UIImage imageNamed:@"icon_HighScoresButton.png"] CGImage];
    
    //Number of particles per second
    confettiCell.birthRate = 0;
    
    //Life in seconds
    confettiCell.lifetime = 1.8;
    confettiCell.lifetimeRange = 10.0;
    
    //Magnitude of initial veleocity with which particles travel
    confettiCell.velocity = 130;
    confettiCell.velocityRange = 200;
    
    //Radial direction of emission of the particles
    confettiCell.emissionRange = 2 * M_PI;
    
    //Spin (angular velocity) of the particles in radians per sec
    //confettiCell.spin = 0.0;
    //confettiCell.spinRange = 4 * M_PI;
    
    //Scaling of the particles
    confettiCell.scale = 1.0;
    confettiCell.scaleRange = 1.0;
    
    //Color Values and their respective Ranges - This helps us create confetti of different colors
//    confettiCell.color = [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor];
//    confettiCell.redRange = 2.0;
//    confettiCell.greenRange = 2.0;
//    confettiCell.blueRange = 2.0;
//    confettiCell.alphaRange = 2.0;
    
    
    //Assign goldStarCell and confettiCell as an array to the emitterCells property of emitterLayer
    emitterLayer.emitterCells = [NSArray arrayWithObjects:confettiCell, goldStarCell,trophyCell, nil];
    
}



//===============================================================
//Touch Handling
//===============================================================
-(void) touchesEnded:(CGPoint )touchPt{
    //If explosion is in progress do nothing on tap and return
    if(isExploding){ return;}
    
    //Fetch the point where user tapped
   // UITouch * touch = [touches anyObject];
    //CGPoint touchPt = [touch locationInView:self.view];
    
    //Set the current position of emitter to the location where the user tapped on the screen
    [self updateEmitterLayerPositionTo:touchPt];
    
    //Start an explosion
    [self startExplosion];
    
    //Schedule a timer for 2 secs during which the user's tap will not cause another explosion (as an existing explosion is in progress)
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(stopExplosion) userInfo:nil repeats:NO];
}

@end
